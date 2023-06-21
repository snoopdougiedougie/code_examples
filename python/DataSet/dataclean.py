import pandas as pd
import streamlit as st
from sklearn.model_selection import train_test_split

def load_and_convert_data(file_path):
    # Load dataset from csv to DataFrame
    df = pd.read_csv(file_path)
    
    # Initialize dictionary to track string to numeric conversions
    conversions = {}
    
    # Convert string values to numeric and track conversions in dictionary
    for col in df.columns:
        if df[col].dtype == object:
            conversions[col] = {val: i for i, val in enumerate(df[col].unique())}
            df[col] = df[col].map(conversions[col])
    
    return df, conversions

def handle_missing_values(df, threshold):
    # Check for missing values
    missing_values = df.isna().sum()
    
    # Impute missing values for records with one missing value
    for col in missing_values[missing_values == 1].index:
        df[col].fillna(df[col].median(), inplace=True)
    
    # Drop records with more than threshold missing value
    df.dropna(thresh=len(df.columns) - threshold, inplace=True)
    
    return df

def split_data(df, test_size):
    return train_test_split(df, test_size=test_size)

def main():
    st.set_page_config(page_title="Data Preprocessing", page_icon=":guardsman:", layout="wide")
    st.title("Data Preprocessing")
    
    file_path = st.text_input("Enter the path/name of the dataset csv file: ")
    test_size = st.number_input("Enter the train/test split size (decimal between 0 and 1): ", step=0.01, value=0.2)
    threshold = st.number_input("Enter the threshold for the number of missing values per record: ", step=1, value=1)
    
    if st.button("Process Data"):
        df, conversions = load_and_convert_data(file_path)
        df = handle_missing_values(df, threshold)
        train_df, test_df = split_data(df, test_size)
        st.success("Data preprocessing completed!")

if __name__ == '__main__':
    main()
