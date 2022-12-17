import base64
import io
import pandas as pd
from dash.dependencies import Input, Output, State
from dash import no_update
import pyreadr
import numpy as np
import os

def handle_file_contents(content_str, filename):
    """Given raw contents of a dash.Upload, handle the parsing and return parsed
    Args:
        content_str (str): Raw content string
        filename (str): Filename
    Returns:
        _type_: _description_
    """
    decoded = no_update
    try:
        if 'rds' in filename:
            # Try reading rds using pyreadr
            temp_file = f"temp{np.random.randint(1, 100)}.rds"
            with open(temp_file, "wb") as f:
                f.write(base64.b64decode(content_str))
            rds_df = pyreadr.read_r(temp_file)[None]
            rds_df = rds_df.rename({'None':'cls'}, axis='columns')
            print(rds_df)
            os.remove(temp_file)
            return rds_df
        decoded = base64.b64decode(content_str)
        decoded = io.StringIO(decoded.decode('utf-8'))
        if 'csv' in filename: decoded = pd.read_csv(decoded)
        elif 'tsv' in filename: decoded = pd.read_csv(decoded, delimiter='\t')
        
    except Exception as e:
        print(e)
    return decoded

def init_file_upload(app):
    @app.callback(
                Output('spatial-store', 'data'),
                Input('upload-data', 'contents'),
                State('upload-data', 'filename'),
                State('upload-data', 'last_modified'))
    def update_output(contents, filename, last_modified):
        if contents is None: return no_update, no_update
        content_type, content_string = contents.split(',')
        out = handle_file_contents(content_string, filename)
        return {"spatial":out.to_json()}
    
    @app.callback(Output('cls-store', 'data'),
                Input('upload-cls', 'contents'),
                State('upload-cls', 'filename'),
                State('upload-cls', 'last_modified'))
    def update_cls(contents, filename, last_modified):
        if contents is None: return no_update
        content_type, content_string = contents.split(',')
        out = handle_file_contents(content_string, filename)
        return {"cls":out.to_json()}