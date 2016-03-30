

    import graphlab

# 6 Degrees of Bureaucracy - LADWP

In this notebook we'll use the Dato GraphLab toolkit to explore LA’s Department of Water and Power projects between 2007 and 2016.  The purpose of this is to find the “Kevin Bacon” of the organization. See Kevin Bacon game.
https://en.wikipedia.org/wiki/Six_Degrees_of_Kevin_Bacon

We will also create a tool that estimates one’s proximity to DWP’s “Kevin Bacon” for any given employee. It is a great way to understand key influencers in your organization.

## Set up and exploratory data analysis

Before we start playing with the data, we need to import some key libraries: graphlab of course, and IPython display utilities. We also tell IPython notebook and GraphLab Canvas to produce plots directly in this notebook.


    from IPython.display import display
    from IPython.display import Image

Our curated data live in an Amazon S3 bucket, from which we could create an SFrame directly, but for this demo we'll first download the CSV file and save it locally. Please note that running this notebook on your machine will download the 8MB csv file to your working directory.


    graphlab.canvas.set_target('ipynb')


    data = graphlab.SFrame.read_csv('cleaned.csv', column_type_hints={'film_name': str,'empl':str})


<pre>Finished parsing file /Users/jmolayem/Desktop/cleaned.csv</pre>



<pre>Parsing completed. Parsed 100 lines in 0.41301 secs.</pre>



<pre>Finished parsing file /Users/jmolayem/Desktop/cleaned.csv</pre>



<pre>Parsing completed. Parsed 324352 lines in 0.375143 secs.</pre>



    data['weight'] = .5
    data.show()




    print "**data overview**"
    display(Image(url='https://s3.amazonaws.com/180data/Screenshot+2016-03-29+22.23.16.png'))

    **data overview**



<img src="https://s3.amazonaws.com/180data/Screenshot+2016-03-29+22.23.16.png"/>



    actors = data['actor_name'].unique()
    films = data['film_name'].unique()
    
    g = graphlab.SGraph()
    g = g.add_edges(data, src_field='actor_name', dst_field='film_name')
    g = g.add_edges(data, src_field='film_name', dst_field='actor_name')
    
    print "Movie graph summary:\n", g.summary(), "\n"

    Movie graph summary:
    {'num_edges': 648704, 'num_vertices': 1614} 
    



    print "Employee vertex sample:"
    g.get_vertices(ids=actors).tail(5)

    Employee vertex sample:





<div style="max-height:1000px;max-width:1500px;overflow:auto;"><table frame="box" rules="cols">
    <tr>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">__id</th>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">8449</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9120</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9219</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9364</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9718</td>
    </tr>
</table>
[5 rows x 1 columns]<br/>
</div>




    cc = graphlab.connected_components.create(g, verbose=False)
    cc_out = cc['component_id']
    print "Connected components summary:\n", cc.summary()

    Connected components summary:
    Class                                   : ConnectedComponentsModel
    
    Graph
    -----
    num_edges                               : 648704
    num_vertices                            : 1614
    
    Results
    -------
    graph                                   : SGraph. See m['graph']
    component size                          : SFrame. See m['component_size']
    number of connected components          : 1
    vertex component id                     : SFrame. See m['componentid']
    
    Metrics
    -------
    training time (secs)                    : 0.5146
    
    Queryable Fields
    ----------------
    graph                                   : A new SGraph with the color id as a vertex property
    component_id                            : An SFrame with each vertex's component id
    component_size                          : An SFrame with the size of each component
    training_time                           : Total training time of the model
    
    None



    cc_size = cc['component_size'].sort('Count', ascending=False)
    cc_size




<div style="max-height:1000px;max-width:1500px;overflow:auto;"><table frame="box" rules="cols">
    <tr>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">component_id</th>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">Count</th>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">128</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">1614</td>
    </tr>
</table>
[1 rows x 2 columns]<br/>
</div>




    big_label = cc_size['component_id'][0]
    big_names = cc_out[cc_out['component_id'] == big_label]
    mainstream_actors = big_names.filter_by(actors, column_name='__id')['__id']


    bacon_films = g.get_edges(src_ids=['10181'])
    
    subgraph = graphlab.SGraph()
    subgraph = subgraph.add_edges(bacon_films, src_field='__src_id',
                                  dst_field='__dst_id')
    subgraph.show(vlabel='id', highlight=['10181'])



Below is the graph viz for employee 10181.


    print "**10181**"
    display(Image(url='https://s3.amazonaws.com/180data/Screenshot+2016-03-29+21.55.55.png'))

    **10181**



<img src="https://s3.amazonaws.com/180data/Screenshot+2016-03-29+21.55.55.png"/>



    bacon_filmss = g.get_edges(src_ids=['9591'])
    
    subgraph = graphlab.SGraph()
    subgraph = subgraph.add_edges(bacon_filmss, src_field='__src_id',
                                  dst_field='__dst_id')
    subgraph.show(vlabel='id', highlight=['9591'])




    print "**9591**"
    display(Image(url='https://s3.amazonaws.com/180data/Screenshot+2016-03-29+22.11.12.png'))

    **9591**



<img src="https://s3.amazonaws.com/180data/Screenshot+2016-03-29+22.11.12.png"/>



    subgraph = graphlab.SGraph()
    
    for f in bacon_films['__dst_id']:
        subgraph = subgraph.add_edges(g.get_edges(src_ids=[f], dst_ids=None),
                                      src_field='__src_id', dst_field='__dst_id')
        
    subgraph.show(highlight=list(bacon_films['__dst_id']), vlabel='__id', vlabel_hover=True)



# Comparing Connections with Other Employees


    def count_in_degree(src, edge, dst):
        dst['in_degree'] += 1
        return (src, edge, dst)
    
    def get_degree(g):
        new_g = graphlab.SGraph(g.vertices, g.edges)
        new_g.vertices['in_degree'] = 0
        return new_g.triple_apply(count_in_degree, ['in_degree']).get_vertices()
    
    degree = get_degree(g)


    comparisons = ['10181', '9591','10416']
    degree.filter_by(comparisons, '__id').sort('in_degree', ascending=False)




<div style="max-height:1000px;max-width:1500px;overflow:auto;"><table frame="box" rules="cols">
    <tr>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">__id</th>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">in_degree</th>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9591</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">550</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">10181</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">97</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">10416</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">10</td>
    </tr>
</table>
[3 rows x 2 columns]<br/>
</div>



## Empl 9591 has the highest degree connections


    actor_degree = degree.filter_by(actors, '__id')
    actor_degree['in_degree'].show()




    actor_degree.topk('in_degree')




<div style="max-height:1000px;max-width:1500px;overflow:auto;"><table frame="box" rules="cols">
    <tr>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">__id</th>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">in_degree</th>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">6428</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">5082</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">7729</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">4789</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">8031</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">4655</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">8231</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">4608</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">8562</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">3993</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">8182</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">3991</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">7984</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">3771</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">6519</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">3742</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">5002</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">3713</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">8257</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">3699</td>
    </tr>
</table>
[10 rows x 2 columns]<br/>
</div>




    sp = graphlab.shortest_path.create(g, source_vid='10181', weight_field='weight', verbose=False)


    sp_graph = sp['graph']


    query = sp_graph.get_vertices(ids=['9591','10181','10416','6428','6326'])
    query.head()




<div style="max-height:1000px;max-width:1500px;overflow:auto;"><table frame="box" rules="cols">
    <tr>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">__id</th>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">distance</th>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">6326</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">1.0</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9591</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">1.0</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">10416</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">1.0</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">6428</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">1.0</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">10181</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">0.0</td>
    </tr>
</table>
[5 rows x 2 columns]<br/>
</div>




    big_label = cc_size['component_id'][0]
    big_names = cc_out[cc_out['component_id'] == big_label]
    mainstream_actors = big_names.filter_by(actors, column_name='__id')['__id']


    bacon_sf = sp_graph.get_vertices(ids=mainstream_actors)
    bacon_sf['distance'].show()



Where there is some approximation in the quantiles shown in the quantile histogram, it's clear that the modal distance from DWP's kevin bacon is 1 hop, with 99% of the nodes falling between 1 and 2 hops.


    print "**Histogram of Modal Distances**"
    display(Image(url='https://s3.amazonaws.com/180data/Screenshot+2016-03-29+22.38.08.png'))

    **Histogram of Modal Distances**



<img src="https://s3.amazonaws.com/180data/Screenshot+2016-03-29+22.38.08.png"/>



    # # Make a container for the centrality statistics
    mean_dists = {}
    
    # # Get statistics for Kevin Bacon - use the already computed KB shortest paths
    mean_dists['10181'] = bacon_sf['distance'].mean()
    
    
    ## Get statistics for the other comparison actors
    for person in comparisons[1:]:
    
        # get single-source shortest paths
        sp2 = graphlab.shortest_path.create(g, source_vid=person,
                                            weight_field='weight',
                                            verbose=False)
        sp2_graph = sp2.get('graph')
        sp2_out = sp2_graph.get_vertices(ids=mainstream_actors)
    
        # Compute some statistics about the distribution of distances
        mean_dists[person] = sp2_out['distance'].mean()


    mean_dists




    {'10181': 1.396840148698885,
     '10416': 1.4990706319702605,
     '9591': 1.3906443618339528}



Once again, empl 9591 comes out ahead, with the smallest mean distance to all other network nodes. Let's take a look at the whole distribution of shortest path distances for him.


    
