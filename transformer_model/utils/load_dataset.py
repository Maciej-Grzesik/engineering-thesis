import os
import pandas as pd

dataset_df = pd.read_json('dataset/WLASL_v0.3.json')

def get_videos_ids(json_lists):
    videos = []
    for record in json_lists:
        video_id = record['video_id']
        if os.path.exists(f'dataset/videos/{video_id}.mp4'):
            videos.append(video_id)

    return videos


print(get_videos_ids(dataset_df.iloc[2]['instances']))

def get_video_names(df):
    for index, row in df.iterrows(): 
        print(row['gloss'], row['instances'], '\n')
        if index >= 0:
            break

print(get_video_names(dataset_df))