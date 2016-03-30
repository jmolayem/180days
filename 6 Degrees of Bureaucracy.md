

    import graphlab


    from IPython.display import display


    from IPython.display import Image


    graphlab.canvas.set_target('ipynb')


    data = graphlab.SFrame.read_csv('cleaned.csv', column_type_hints={'film_name': str,'empl':str})


<pre>Finished parsing file /Users/jmolayem/Desktop/cleaned.csv</pre>



<pre>Parsing completed. Parsed 100 lines in 0.41301 secs.</pre>



<pre>Finished parsing file /Users/jmolayem/Desktop/cleaned.csv</pre>



<pre>Parsing completed. Parsed 324352 lines in 0.375143 secs.</pre>



    data.rename({'empl':'actor_name'})




<div style="max-height:1000px;max-width:1500px;overflow:auto;"><table frame="box" rules="cols">
    <tr>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">id</th>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">actor_name</th>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">character</th>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">film_name</th>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">0</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9901</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">Adam Riley</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">600353</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">1</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9901</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">Captain' Robert Jackson</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">900984</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">2</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9901</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">Jacob Krause</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">104113</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">3</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9901</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">Carissa</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">104113</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">4</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9901</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">Commander Fredericks</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">103934</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">5</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9901</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">Peter McCollum</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">104180</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">6</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9901</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">Charles Baker</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">104558</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">7</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9901</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">Global Chairman</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">104552</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">8</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9901</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">President of the United<br>States ...</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">104636</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9901</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">Audrey Thomas</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">600353</td>
    </tr>
</table>
[324352 rows x 4 columns]<br/>Note: Only the head of the SFrame is printed.<br/>You can use print_rows(num_rows=m, num_columns=n) to print more rows and columns.
</div>




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
    training time (secs)                    : 0.2497
    
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




    subgraph = graphlab.SGraph()
    
    for f in bacon_films['__dst_id']:
        subgraph = subgraph.add_edges(g.get_edges(src_ids=[f], dst_ids=None),
                                      src_field='__src_id', dst_field='__dst_id')
        
    subgraph.show(highlight=list(bacon_films['__dst_id']), vlabel='__id', vlabel_hover=True)




    def count_in_degree(src, edge, dst):
        dst['in_degree'] += 1
        return (src, edge, dst)
    
    def get_degree(g):
        new_g = graphlab.SGraph(g.vertices, g.edges)
        new_g.vertices['in_degree'] = 0
        return new_g.triple_apply(count_in_degree, ['in_degree']).get_vertices()
    
    degree = get_degree(g)


    comparisons = ['10181', '9901']
    degree.filter_by(comparisons, '__id').sort('in_degree', ascending=False)




<div style="max-height:1000px;max-width:1500px;overflow:auto;"><table frame="box" rules="cols">
    <tr>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">__id</th>
        <th style="padding-left: 1em; padding-right: 1em; text-align: center">in_degree</th>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">9901</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">393</td>
    </tr>
    <tr>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">10181</td>
        <td style="padding-left: 1em; padding-right: 1em; text-align: center; vertical-align: top">97</td>
    </tr>
</table>
[2 rows x 2 columns]<br/>
</div>




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




    
