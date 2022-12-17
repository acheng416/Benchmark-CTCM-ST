from dash import Dash, html, dcc, no_update
import dash_mantine_components as dmc

app = Dash(__name__)


app.layout = html.Div(
    children=[
        dcc.Store(data={},id='cls-store'),
        dcc.Store(data={},id='spatial-store'),
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
                html.H4("Marker Size: "),
                dmc.Slider(min=1, max=20, step=0.5, value=5, id="marker-slider",
                    style={"width":"50%"}           
                ),
                html.H4("Plot Width: "),
                dmc.Slider(min=1, max=100, step=1, value=50, id="width-slider",
                    style={"width":"50%"}           
                ),
                html.H4("Plot Height: "),
                dmc.Slider(min=1, max=100, step=1, value=50, id="height-slider",
                    style={"width":"50%"}           
                )
            ],
            shadow="md", p ="xl", 
            style={'width':"30%", 'height':"50%","backgroundColor": "#FCFCFC",
                   "display": "flex", "justifyContent":"center", "alignItems":"center",
                   "flexDirection": "column"
                   
            }
        ),
        dmc.Paper(
                children=[
                dcc.Loading(dcc.Graph(id="graph"), type="dot"),
            ],
            id="graph-parent",
            shadow="md", radius="md", p ="xl", style={'width':"70%"}
        ),
    ],
    style = {'display':'flex', 'alignItems': "flex-start"}
)
if __name__ == '__main__':
    from callbacks.file_upload import init_file_upload
    from callbacks.plot import init_plot_callbacks
    init_file_upload(app)
    init_plot_callbacks(app)
    app.run_server(debug=True)