from dash.dependencies import Input, Output, State
import plotly.express as px
from dash import no_update
import pandas as pd

def build_graph(spatial_info, cls = None, **kwargs):
    if spatial_info is None: return None
    spatial_info = pd.read_json(spatial_info, orient='columns')
    spatial_info = spatial_info.iloc[:,1:]
    if cls is not None:
        cls = pd.read_json(cls, orient='columns')
        if len(cls) == len(spatial_info):
            spatial_info['cls'] = cls.astype(str)
            fig = px.scatter(spatial_info, 
                             x=spatial_info.iloc[:,0],
                             y=spatial_info.iloc[:,1], 
                             color="cls"
            )
        else:
            fig = px.scatter(spatial_info, *spatial_info.columns)
    else:
        fig = px.scatter(spatial_info, *spatial_info.columns)
    fig.update_layout(
        {
            'plot_bgcolor': 'rgba(0,0,0,0)',
            'paper_bgcolor': 'rgba(0,0,0,0)'
        }
    )
    print(kwargs["marker"])
    fig.update_traces(marker=kwargs["marker"])
    fig.update_xaxes(showgrid=False)
    fig.update_yaxes(showgrid=False)
    return fig

def init_plot_callbacks(app):
    @app.callback(
        Output('graph', 'figure'),
        Input('spatial-store', 'data'),
        Input('cls-store', 'data'),
        Input('marker-slider', 'value')
    )
    def update_graph(spatial, cls_dict, size):
        if spatial is None or type(spatial) == list: return no_update
        cls = cls_dict.get("cls")
        spatial_info = spatial.get("spatial")
        marker = {"size":size}
        fig = build_graph(spatial_info, cls = cls, marker=marker)
        return fig
    
    @app.callback(
        Output('graph-parent', 'style'),
        Input('width-slider', 'value'),
        Input('height-slider', 'value')
    )
    def update_graph(width_percent, height_percent):
        return {
            "width": f"{width_percent}%",
            "height": f"{height_percent}%"
        }