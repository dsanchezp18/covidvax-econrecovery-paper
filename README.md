# *Immunizing the Economy: A Causality Discussion on Vaccines and Economic Recovery*

Source code for my paper *Immunizing the Economy: A Causality Discussion on Vaccines and Economic Recovery*, published to the X-Pedientes Económicos Journal from Ecuador's Superintendencia de Compañías, Valores y Seguros (SCVS), a top regulatory and public policy institution. Includes the data used, my .Rproject file and my RMarkdown file (the journal required a .docx document) with the paper's text and code for the regression analyses. Only the wild bootstrap tests were done outside the .Rproject, which will be featured in the preliminary analysis GitHub repository. 

As of April 2022, a bug seems to have affected the R package *fwildboostrap*, which is why I commented out all bootstrap tests for the paper. You can see the actual results of the test in the [paper's text](https://ojs.supercias.gob.ec/index.php/X-pedientes_Economicos/article/view/103). 

As of July 2022, I have deleted the RMarkdown file and included a Quarto file (`.qmd`). This was the result of my own self-teaching session of Quarto- the next generation of RMarkdown. I have also included the stata files which I used to produce the wild boostrap tests with the Stata `boottest` command, as the `boottest` command from R of the *fwildclusterboot* library seems to produce errors in some models. 

As before, don't hesitate to contact me if you need anything else. 
