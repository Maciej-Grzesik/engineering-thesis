import cv2
import mediapipe as mp
import torch
import pandas as pd
import numpy as np
import ast

from models.spoter_model_original import SPOTER, SPOTERnoPE
from google.protobuf.json_format import MessageToDict

CHECKPOINT_PATH = "src/out-checkpoints/2WLASL100_SPOTERnoPE_mediaPipeHP/test_WLASL100_Spoter_noNorm_noAugm_mediaPipe_HandsAndPoseV3NoPosEmb/checkpoint_v_23.pth"
HIDDEN_DIM = 150
N_HEADS = 10
NUM_CLASSES = 100


def load_model():
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
    
    Parameters:
        hands: Mediapipe hands detection model.
        pose: Mediapipe pose detection model.
        frames: List of video frames (numpy arrays).
        columns: List of column names for the DataFrame.
        out_path: Output path for the structured CSV.
        padVal: Padding value for missing landmarks.
    """
    video_df = pd.DataFrame(columns=columns)

    for idx, frame in enumerate(frames):
        # Create a DataFrame with padded values for each frame
        df_handsBody_coordinates = pd.DataFrame(padVal * np.ones(shape=(1, len(columns))), columns=columns)
        try:
            # Convert the BGR frame to RGB before processing
            results = hands.process(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))
            results_p = pose.process(cv2.cvtColor(frame, cv2.COLOR_BGR2RGB))

            # Process hand landmarks
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

            # Process pose landmarks
            if results_p.pose_landmarks:
                for i in range(len(results_p.pose_landmarks.landmark)):
                    x = results_p.pose_landmarks.landmark[i].x
                    y = results_p.pose_landmarks.landmark[i].y
                    df_handsBody_coordinates["Px" + str(i)] = x
                    df_handsBody_coordinates["Py" + str(i)] = y

            # Append the row to video_df
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

    with open('test.csv', 'w') as fp:
        fp.write('%s\n' % ','.join(video_df.columns))
        for col in video_df.columns:
            if col == video_df.columns[-1]:  # Last column
                fp.write('"%s"\n' % np.array2string(video_df[col].values, separator=',').replace("\n ", "").strip())
            else:
                fp.write('"%s",' % np.array2string(video_df[col].values, separator=',').replace("\n ", "").strip())

    print(f"Data saved to ")
    

def load_dataset_mediaPipe(file_location: str, n_landm=42):
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
    outputs = model(data).expand(1, -1, -1)
    prediction = int(torch.argmax(torch.nn.functional.softmax(outputs, dim=2)))
    
    return prediction

def use_labels(labels_path, prediction):
    df = pd.read_csv(labels_path, sep=';')
    for row in df.itertuples():
        if row.gloss_number == prediction:  
            return row.gloss_name



def main():
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model = load_model()
    
    mp_hands = mp.solutions.hands
    mp_pose = mp.solutions.pose
    mp_drawing = mp.solutions.drawing_utils 

    hands = mp_hands.Hands(static_image_mode=False, max_num_hands=2, min_detection_confidence=0.5)
    pose = mp_pose.Pose(static_image_mode=False, min_detection_confidence=0.5)

    cap = cv2.VideoCapture(1)
    
    columns1 = [["RHx" + str(i), "RHy" + str(i)] for i in range(21)]
    columns2 = [["LHx" + str(i), "LHy" + str(i)] for i in range(21)]
    columns3 = [["Px" + str(i), "Py" + str(i),] for i in range(33)]
    columns = np.concatenate((columns1, columns2), axis=0)
    columns = np.concatenate((columns, columns3), axis=0)
    columns = [item for sublist in columns for item in sublist]

    frames = []
    
    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break
        frames.append(frame)
        if len(frames) >= 50:
            extract_XY(hands, pose, frames, columns=columns)

            inputs = load_dataset_mediaPipe('test.csv', n_landm=int(HIDDEN_DIM / 2))
            print(f"Loaded inputs type: {type(inputs)}")
            inputs = torch.tensor(np.array(inputs), dtype=torch.float32)  # Ensure tensor
            print(f"Type of inputs: {type(inputs)}")
            print(f"Inputs: {inputs}")

            inputs = inputs.squeeze(0).to(device)
            print(f"Converted inputs type: {type(inputs)}, shape: {inputs.shape}")

            outputs = model(inputs).expand(1, -1, -1)
            pred = int(torch.argmax(torch.nn.functional.softmax(outputs, dim=2)))

            frames.clear() 
            print(f"Prediction: {pred}")
            predicted_word = use_labels('WLASL100_dir/WLASL100_v0.3.csv', pred)
            print(f'Word: {predicted_word}')

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results_hands = hands.process(frame_rgb)
        results_pose = pose.process(frame_rgb)

        if results_hands.multi_hand_landmarks:
            for hand_landmarks in results_hands.multi_hand_landmarks:
                mp_drawing.draw_landmarks(frame, hand_landmarks, mp_hands.HAND_CONNECTIONS)

        if results_pose.pose_landmarks:
            mp_drawing.draw_landmarks(frame, results_pose.pose_landmarks, mp_pose.POSE_CONNECTIONS)

        cv2.imshow('Kamera', frame)

    cap.release()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    main()