from dash import Dash, html, dcc, no_update
import dash_mantine_components as dmc

app = Dash(__name__)


app.layout = html.Div(
    children=[
        dmc.Paper(
            children = [
                dcc.Upload(
                    html.A('Select Clusters', className="upload-text"),
                    className="upload",
                    id='upload-cls', accept = ".rds"
                ),
                dcc.Upload(
                    html.A('Select Spatial Coordinates', className="upload-text"),
                    className="upload",
                    id='upload-data', accept = ".tsv"
                ),
            ],
            shadow="md", p ="xl", 
            style={'width':"30%", "backgroundColor": "#FCFCFC",
                   "display": "flex", "justifyContent":"center", "alignItems":"center"
                   
            }
        ),
        dmc.Paper(
                children=[
                dcc.Graph(id="graph"),
                html.Div(id="output-data-upload")
            ],
            shadow="md", radius="md", p ="xl", style={'width':"70%"}
        ),
    ],
    style = {'display':'flex', 'justify-content': "center"}
)
if __name__ == '__main__':
    from callbacks.file_upload import init_file_upload
    init_file_upload(app)
    app.run_server(debug=True)