import base64
import os
from flask import Flask, request, jsonify
import cv2
import mediapipe as mp
import torch
import pandas as pd
import numpy as np
import ast
from models.spoter_model_original import SPOTERnoPE
from google.protobuf.json_format import MessageToDict

app = Flask(__name__)

CHECKPOINT_PATH = "src/out-checkpoints/2WLASL100_SPOTERnoPE_mediaPipeHP/test_WLASL100_Spoter_noNorm_noAugm_mediaPipe_HandsAndPoseV3NoPosEmb/checkpoint_v_23.pth"
HIDDEN_DIM = 150
N_HEADS = 10
NUM_CLASSES = 100


def load_model():
    """
    Load the SPOTER model with the specified parameters and checkpoint.

    Returns:
        model (torch.nn.Module): The loaded SPOTER model.
    """
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model = SPOTERnoPE(num_classes=NUM_CLASSES, hidden_dim=HIDDEN_DIM, n_heads=N_HEADS)    
    model.load_state_dict(torch.load(CHECKPOINT_PATH, map_location=torch.device('cpu')).state_dict())
    model.eval()
    model.train(False)
    
    model.to(device)
    return model



def extract_XY(hands, pose, frames, columns, padVal=-2):
    """
    Extract landmarks from video frames and save them in a structured CSV format,
    where each column contains the entire array of values as a single cell.

    Args:
        hands (list): List of hand landmarks.
        pose (list): List of pose landmarks.
        frames (list): List of video frames.
        columns (list): List of column names for the CSV.
        padVal (int, optional): Padding value for missing landmarks. Defaults to -2.

    Returns:
        None
    """
    video_df = pd.DataFrame(columns=columns)

    for idx, frame in enumerate(frames):
        df_handsBody_coordinates = pd.DataFrame(padVal * np.ones(shape=(1, len(columns))), columns=columns)
        try:
            results = hands.process(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
            results_p = pose.process(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))

            if results.multi_hand_landmarks:
                for iVal, hand_handedness in enumerate(results.multi_handedness):
                    handedness_dict = MessageToDict(hand_handedness)
                    handDetected = handedness_dict['classification'][0]["label"]
                    hand2process = "LH" if handDetected == "Left" else "RH"

                    hand_landmarks = results.multi_hand_landmarks[iVal]
                    for i in range(len(hand_landmarks.landmark)):
                        x = hand_landmarks.landmark[i].x
                        y = hand_landmarks.landmark[i].y
                        df_handsBody_coordinates[hand2process + "x" + str(i)] = x
                        df_handsBody_coordinates[hand2process + "y" + str(i)] = y

            if results_p.pose_landmarks:
                for i in range(len(results_p.pose_landmarks.landmark)):
                    x = results_p.pose_landmarks.landmark[i].x
                    y = results_p.pose_landmarks.landmark[i].y
                    df_handsBody_coordinates["Px" + str(i)] = x
                    df_handsBody_coordinates["Py" + str(i)] = y

            video_df = pd.concat([
                video_df,
                pd.DataFrame(
                    [df_handsBody_coordinates.values[0]],
                    columns=columns
                )
            ], ignore_index=True)

        except Exception as e:
            print(f"Error in extract_XY: {e}")
            with open('logs.txt', 'a') as f:
                f.write(f"Error at {idx + 1}, frame: {str(e)}\n")

    with open('predict.csv', 'w') as fp:
        fp.write('%s\n' % ','.join(video_df.columns))
        for col in video_df.columns:
            if col == video_df.columns[-1]:
                fp.write('"%s"\n' % np.array2string(video_df[col].values, separator=',').replace("\n ", "").strip())
            else:
                fp.write('"%s",' % np.array2string(video_df[col].values, separator=',').replace("\n ", "").strip())

    print(f"Data saved to ")


def load_dataset_mediaPipe(file_location: str, n_landm=42):
    """
    Load a dataset from a CSV file and convert it to a tensor.

    Args:
        file_location (str): Path to the CSV file.
        n_landm (int, optional): Number of landmarks. Defaults to 42.

    Returns:
        torch.Tensor: The loaded dataset as a tensor.
    """
    df = pd.read_csv(file_location, encoding="utf-8")

    data = []
    for row_index, row in df.iterrows():
        current_row = np.empty(shape=(len(ast.literal_eval(row[df.columns[0]])), n_landm, 2))
        for land_i in range(n_landm):
            current_row[:, land_i, 0] = ast.literal_eval(row[df.columns[0::2][land_i]]) # X
            current_row[:, land_i, 1] = ast.literal_eval(row[df.columns[1::2][land_i]]) # Y
        data.append(current_row)
    
    return torch.tensor(np.array(data), dtype=torch.float32)


def predict(model, data):
    """
    Make a prediction using the SPOTER model.

    Args:
        model (torch.nn.Module): The SPOTER model.
        data (torch.Tensor): The input data for prediction.

    Returns:
        int: The predicted class.
    """
    outputs = model(data).expand(1, -1, -1)
    prediction = int(torch.argmax(torch.nn.functional.softmax(outputs, dim=2)))
    
    return prediction


def use_labels(labels_path, prediction):
    """
    Map the predicted class to the corresponding label.

    Args:
        labels_path (str): Path to the CSV file containing labels.
        prediction (int): The predicted class.

    Returns:
        str: The corresponding label for the predicted class.
    """
    df = pd.read_csv(labels_path, sep=';')
    for row in df.itertuples():
        if row.gloss_number == prediction:
            return row.gloss_name


@app.route('/predict', methods=['POST'])
def predict_endpoint():
    """
    Flask endpoint to handle prediction requests.

    Returns:
        Response: JSON response containing the prediction or an error message.
    """
    model = load_model()
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    mp_hands = mp.solutions.hands
    mp_pose = mp.solutions.pose
    hands = mp_hands.Hands(static_image_mode=False, max_num_hands=2, min_detection_confidence=0.5)
    pose = mp_pose.Pose(static_image_mode=False, min_detection_confidence=0.5)
    
    columns1 = [["RHx" + str(i), "RHy" + str(i)] for i in range(21)]
    columns2 = [["LHx" + str(i), "LHy" + str(i)] for i in range(21)]
    columns3 = [["Px" + str(i), "Py" + str(i)] for i in range(33)]
    columns = np.concatenate((columns1, columns2), axis=0)
    columns = np.concatenate((columns, columns3), axis=0)
    columns = [item for sublist in columns for item in sublist]
    
    try:
        data = request.get_json()
        video_base64 = data['video']

        video_data = base64.b64decode(video_base64)
        video_path = "received_video.mp4"
        with open(video_path, "wb") as video_file:
            video_file.write(video_data)

        video_capture = cv2.VideoCapture(video_path)
        if not video_capture.isOpened():
            return jsonify({"error": "Failed to open video file"}), 400

        frames = []
        while True:
            ret, frame = video_capture.read()
            if not ret:
                break
            frames.append(frame)

        video_capture.release()
        os.remove(video_path) 

        extract_XY(hands, pose, frames, columns)

        inputs = load_dataset_mediaPipe('predict.csv', n_landm=int(HIDDEN_DIM / 2))        
        inputs = torch.tensor(np.array(inputs), dtype=torch.float32)
        inputs = inputs.squeeze(0).to(device)

        outputs = model(inputs).expand(1, -1, -1)
        prediction = int(torch.argmax(torch.nn.functional.softmax(outputs, dim=2)))

        frames.clear() 
        predicted_word = use_labels('WLASL100_dir/WLASL100_v0.3.csv', prediction)
        
        return jsonify({"prediction": prediction, "word": predicted_word})

    except KeyError as e:
        return jsonify({"error": f"Missing key: {str(e)}"}), 400
    except ValueError as e:
        return jsonify({"error": f"Value error: {str(e)}"}), 400
    except Exception as e:
        return jsonify({"error": f"Unexpected error: {str(e)}"}), 400


if __name__ == "__main__":
    app.config['MAX_CONTENT_LENGTH'] = 1000 * 1024 * 1024
    app.run(host="0.0.0.0", port=6000)
