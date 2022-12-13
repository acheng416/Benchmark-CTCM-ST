import base64
import io
import pandas as pd
import plotly.express as px
from dash.dependencies import Input, Output, State
from dash import no_update

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
        decoded = base64.b64decode(content_str)
        decoded = io.StringIO(decoded.decode('utf-8'))
        if 'csv' in filename: decoded = pd.read_csv(decoded)
        elif 'tsv' in filename: decoded = pd.read_csv(decoded, delimiter='\t')
    except Exception as e:
        print(e)
    return decoded

def build_graph(spatial_info, cls = None):
    if spatial_info is None: return None
    spatial_info = spatial_info.iloc[:,1:]
    fig = px.scatter(spatial_info, *spatial_info.columns)
    fig.update_layout(
        {
            'plot_bgcolor': 'rgba(0,0,0,0)',
            'paper_bgcolor': 'rgba(0,0,0,0)'
        }
    )
    fig.update_xaxes(showgrid=False)
    fig.update_yaxes(showgrid=False)
    return fig

def init_file_upload(app):
    @app.callback(Output('output-data-upload', 'children'),
                Output('graph', 'figure'),
                Input('upload-data', 'contents'),
                State('upload-data', 'filename'),
                State('upload-data', 'last_modified'))
    def update_output(contents, filename, last_modified):
        if contents is None: return no_update, no_update
        content_type, content_string = contents.split(',')
        out = handle_file_contents(content_string, filename)
        if type(out) == pd.DataFrame: out = build_graph(out)
        return no_update, out