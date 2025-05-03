
library(shiny)

navbarPage(
  id = 'path_navbar',
  title = div(
    HTML('<span style="font-size:180%;color:white;font-weight:bold;"> DrugSurvPlot</span></a>'),
    tags$style(style = 'position:absolute; right:42px;'),
    tags$style(type="text/css", ".navbar-brand {padding-top: 23px;}"),
    tags$style(HTML("#panel1{font-size: 18px}")),
    tags$style(HTML("#panel2{font-size: 18px}")),
    tags$style(HTML("#panel3{font-size: 18px}")),
    tags$style(HTML("#panel4{font-size: 18px}"))
  ),
  theme = shinytheme('flatly'),
  fluid = T,#TRUE to use a fluid layout
  windowTitle = "DrugSurvPlot",#the browser window title
  ###### 插入依赖项 ######
  header = tagList(
    useShinydashboardPlus(),
    useShinyjs(),
    use_shinyscroll()
  ),
  #----------------tabPanel1.home page----------------------
  
  tabPanel(h4(id = "panel1", "Home"),
           value = "panel1",
           fluidRow(
             column(12,
                    tags$h1("DrugSurvPlot"),
                    h4("DrugSurvPlot (Pan-Cancer Drug Sensitivity Score Survival Analysis) is a large-scale interactive web tool dedicated to pan-cancer survival analysis and visualization by using results from drug sensitivity score. With DrugSurvPlot, users can quickly explore the impact of target drug on survival outcomes in different tumors, assisting clinicians and researchers in further investigating the mechanism of tumor development and improving clinical decision-making.",
                       br(),
                       HTML(#'<br/>',
                            #'<p><b>Please cite:</b><a href="https://pubmed.ncbi.nlm.nih.gov/38717988/" target="_blank">Yang H, Shi Y, Lin A, Qi C, Liu Z, Cheng Q, Miao K, Zhang J, Luo P. PESSA: A web tool for pathway enrichment score-based survival analysis in cancer. PLoS Comput Biol. 2024 May 8;20(5):e1012024.</a></p>',
                            '<br/>',
                            '<p><b>DrugSurvPlot is accessible at:</b> <a href="https://smuonco.shinyapps.io/DrugSurvPlot/" target="_blank">https://smuonco.shinyapps.io/DrugSurvPlot/</a></p>'
                            #and <a herf= "http://robinl-lab.com/PESSA" target="_blank">http://robinl-lab.com/PESSA</a></p>'
                            ),
                       br())
             )
           ),
           tags$hr(),
           fluidRow(column(7,
                           align = "center",
                           tags$img(src="www/PANCAN.png", width="90%", alt="Something went wrong...Please refresh page.")),
                    tags$style(HTML(".intro_text {margin-top: 30px;}")),
                    column(5,
                           div(class = "intro_text",
                               tags$h3(strong("How does DrugSurvPlot work?")),
                               tags$br(),
                               h4("STEP1: Select Data to Be Processed"),
                               h4("STEP2: View Analysis Results"),
                               h4("STEP3: Costomize and Download Your Plot"),
                               tags$br(),
                               actionButton(inputId = "homebtn", label = h4(strong("Get Started Now >>"))))
                    )
           ),
           tags$hr(),
           fluidRow(column(5,
                           HTML('<h3><b>Updates</b></h3>',
                                '<h4>12/04/25 Version 1.0.0 of DrugSurvPlot released.</h4>')),
                    # column(6,
                    #        class = 'footer-container',
                    #        HTML('<div style="text-align: center;"><div style="display:inline-block;width: 50px; height: 50px;"><script type="text/javascript" id="clstr_globe" src="//clustrmaps.com/globe.js?d=JC-fJrXcinH7LNGsiXGoz2iGrzyTcTkE4EaqC0tbBEE"></script></div> </div>
                    #               <div style="text-align: center;"><p>Copyright © 2023. All rights reserved.</p></div>'))
                    
           ),
           fluidRow(column(6,
                         class = 'footer-container',
                        HTML('<div style="text-align: center;"><div style="display:inline-block;width: 50px; height: 50px;"><script type="text/javascript" id="clstr_globe" src="//clustrmaps.com/globe.js?d=32vBspeoBTB5vqAXgNsy3uGMJDS69KYge15FJAzASTk"></script></div> </div>
                            <div style="text-align: center;"><p>Copyright © 2025. All rights reserved.</p></div>'))),
           tags$style(HTML(".footer-container {width: 100%; /*for nothing*/
                             bottom: 0; /*for nothing*/
                             left: 0; /*for nothing*/
                             position: static;
                             padding: 0;/*IMPORTANT! W/0 PADDING*/;
                             }")) 
           
  ),
  
  #-------------------------tabPanel2.PLOT------------------------------ 
  tabPanel(h4(id = "panel2", "PLOT!"),
           value = "panel2",
           # 2.1.1 box1: select & filter input data ----------------------------------------
           fluidRow(
             box(id = "drug_selectbox",
                 title = strong("STEP1: Select Data to Be Processed", style = 'font-size:18px;color:white;'),
                 icon = icon("upload"),
                 collapsible = FALSE,
                 collapsed = FALSE,
                 status = "black", solidHeader = TRUE, width = 12,
                 fluidRow(
                   column(6, selectizeInput(inputId = "select.drug",
                                            label = "Select a drug",
                                            choices = NULL, 
                                            multiple = FALSE,
                                            options = list(
                                              placeholder = "Type the drug name of your interests",
                                              maxItems = 1
                                            )) %>% helper(type = "inline",
                                                          title = "DRUG SELECTION",
                                                          content = c("Please make sure you type the <b>right</b> drug.",
                                                                      "You can check it further in the ABOUT page.")),
                          actionButton(inputId = "submitdata_btn", label = "Analyze!", style = 'margin-top:25px'),
                          downloadButton(outputId = "downloaddata_btn", class = "downloadbtn", label = "DOWNLOAD RESULTS", style = 'margin-top:25px')
                   ),
                   column(6, 
                          box(textOutput("syn"),textOutput("tar"),textOutput("tar_path"),title = strong("Brief Description"), status = "success", width = 12,   
                              HTML('<p>For more information, please refer to the website</p>'),
                              uiOutput("web") 
                          )
                   )
                 ))
           ),
           # 2.1.2 box2: show results datatable ----------------------------------------
           fluidRow(
             shiny::includeScript("www/script.js"),# js for buttons
             tags$style(HTML("div.datatables {width: auto; height: auto;}")),
             box(id = "drug_tablebox",
                 title = strong("STEP2: View Analysis Results", style = 'font-size:18px;color:white;'),
                 icon = icon("table"),
                 collapsible = TRUE,
                 collapsed = TRUE,
                 status = "black", solidHeader = TRUE, width = 12,
                 # fluidRow(column(12, Spinner(id = "test", size = 3, label = "Loading, please wait..."))),
                 # fluidRow(column(12, dataTableOutput("kmresultdt")))
                 fluidRow(column(12, shinycssloaders::withSpinner(shiny::uiOutput("drugresultdt"), color = "black")))
             )
           ),
           # 2.1.3 box3: show the plot and download ----------------------------------------
           fluidRow(
             tags$style(HTML(".panel {border: 0;-webkit-box-shadow: 0 0 0;box-shadow: 0 0 0;}
                           .panel-default > .panel-heading {color: blue;background-color: transparent;border-color: transparent;}")),
             box(id = "drug_plotbox",
                 title = strong("STEP3: View, Costomize and Download Your Plot", style = 'font-size:18px;color:white;'),
                 icon = icon("square-check"),
                 collapsible = TRUE,
                 collapsed = TRUE,
                 status = "black", solidHeader = TRUE, width = 12,
                 fluidRow(column(12,wellPanel(htmlOutput("DTselectinfo")))),
                 fluidRow(column(1, downloadButton(outputId = "download_KMdrug", label = "Download", icon=icon("download")))),
                 br(),
                 fluidRow(column(3, shinyBS::bsCollapsePanel("CUSTOMIZE OPTIONS>>",
                                                             fluidRow(column(6, colorPickr(inputId = "drug_low_color", label = "LOW:", selected = "#c35f50", theme = "monolith", update ="change")),
                                                                      column(6, colorPickr(inputId = "drug_high_color", label = "HIGH:", selected = "#477aae", theme = "monolith", update ="change"))),
                                                             fluidRow(column(12, radioButtons(inputId = "cutoff_KMdrug", label = "Choose a method for the cutpoint", choiceNames = list("Median", "Optimal (maximally selected rank statistics)"), choiceValues = list("m", "b"),inline = FALSE, selected = "m"))),
                                                             fluidRow(column(2, actionButton(inputId = "customize_drugbtn", label = "proceed!")),
                                                                      column(2, offset = 2, actionBttn(inputId = "customize_defalutbtn", label = "Default", style = "minimal", color = "primary", size = "sm")))
                 )),
                 column(5, offset = 1, shinycssloaders::withSpinner(plotOutput("KMdrug_plot"), color = "black")))
             )
           )),
  # 3. tab_panel_3_DATA -------------------------------------------------
  tabPanel(h4(id = "panel3", "Data"),
           value = "panel3",
           fluidRow(
             box(id = "drug_infotbbox",
                 title = strong("DATASETS DESCRIPTION", style = 'font-size:18px;color:white;'),
                 icon = icon("table"),
                 collapsible = FALSE,
                 collapsed = FALSE,
                 status = "black", solidHeader = TRUE, width = 12,
                 fluidRow(column(12, shinycssloaders::withSpinner(dataTableOutput("kminfodt"), color = "black")))
             )
           )),
  # 4. tab_panel_4_about ----------------------------------------------------
  tabPanel(h4(id = "panel4", "About"),
           value = "panel4",
           fluidRow(
             box(id = "contactbox",
                 title = strong("Contact", style = 'font-size:18px;color:white;'),
                 icon = icon("users"),
                 collapsible = FALSE,
                 collapsed = FALSE,
                 status = "black", solidHeader = TRUE, width = 12,
                 HTML('<p>Should you have any questions, please feel free to contact us.</p>',
                      '<p>Peng Luo: <a href="mailto:luopeng@smu.edu.cn">luopeng@smu.edu.cn</a> </p>',
                      '<p>Ying Shi: <a href="mailto:shoshanashi@i.smu.edu.cn">shoshanashi@i.smu.edu.cn</a></p>',
                      '<p>Qirui Shen: <a href="mailto:shenqr@i.smu.edu.cn">shenqr@i.smu.edu.cn</a></p>',
                      '<br/>',
                      '<p>Our lab has a long-standing interest in cancer biomedical research and bioinformatics. We recently developed several other Shiny web tools focusing on solving various scientific questions.</p>',
                      '<p><a href="http://www.camoip.net" target="_blank">CAMOIP</a>: A Web Server for Comprehensive Analysis on Multi-omics of Immunotherapy in Pan-cancer. doi: <a href="https://doi.org/10.1093/bib/bbac129" target="_blank">10.1093/bib/bbac129</a></p>',
                      '<p><a href="https://smuonco.Shinyapps.io/Onlinemeta/" target="_blank">Onlinemeta</a>: A Web Server For Meta-Analysis Based On R-shiny. doi: <a href="https://doi.org/10.1101/2022.04.13.488126" target="_blank">10.1101/2022.04.13.488126[preprint]</a></p>',
                      '<p><a href="https://smuonco.shinyapps.io/PanCanSurvPlot/" target="_blank">PanCanSurvPlot</a>: A Large-scale Pan-cancer Survival Analysis Web Application. doi: <a href="https://doi.org/10.1101/2022.12.25.521884" target="_blank">10.1101/2022.12.25.521884[preprint]</a></p>',
                      '<p><a href="https://smuonco.shinyapps.io/PESSA/" target="_blank">PESSA</a>: A web tool for pathway enrichment score-based survival analysis in cancer. doi: <a href="https://doi.org/10.1371/journal.pcbi.1012024" target="_blank">10.1371/journal.pcbi.1012024</a></p>',
                      '<p><a href="https://smuonco.shinyapps.io/CPADS/" target="_blank">CPADS</a>: A web tool for comprehensive pancancer analysis of drug sensitivity. doi: <a href="https://doi.org/10.1093/bib/bbae237" target="_blank">10.1093/bib/bbae237</a></p>',
                      '<p><a href="https://smuonco.shinyapps.io/PDMSA/" target="_blank">PDMSA</a>: A web tool for DNA methylation level-based survival analysis in cancer.</p>'
                 )
             )
           ),
           fluidRow(
             box(id = "tutorialbox",
                 title = strong("Tutorial Video", style = 'font-size:18px;color:white;'),
                 icon = icon("youtube"),
                 collapsible = TRUE,
                 collapsed = TRUE,
                 status = "black", solidHeader = TRUE, width = 12,
                 fluidRow(column(6, offset=3, HTML('<iframe width="560" height="315" src="https://youtu.be/IIAWv09hyPI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>'))),
                 fluidRow(column(6, offset=3, HTML('<p>For users who can not access, the tutorial video is also available on <a href="https://www.bilibili.com/video/BV1RmLezGEv2" target="_blank">Bilibili</a>.</p>')))
             )
           ),
           fluidRow(
             box(id = "commentbox",
                 title = strong("Comment Box", style = 'font-size:18px;color:white;'),
                 icon = icon("envelope"),
                 collapsible = TRUE,
                 collapsed = TRUE,
                 status = "black", solidHeader = TRUE, width = 12,
                 useSweetAlert("borderless", ie = F),#"sweetalert2", "minimal", "dark", "bootstrap-4", "material-ui", "bulma","borderless"
                 fluidRow(column(8,
                                 textInput(inputId = "contact", label = "Name/Email (optional)", width = "60%"),
                                 textAreaInput(inputId = "comment", label = labelMandatory("Comment"), placeholder = "Enter your comment here", width = "100%", height = "100px"),
                                 actionButton("submit_commentbtn", "Submit Comment")
                 ))
             )
           ),
           fluidRow(
             box(id = "updatesbox",
                 title = strong("Update History", style = 'font-size:18px;color:white;'),
                 icon = icon("file-pen"),
                 collapsible = TRUE,
                 collapsed = FALSE,
                 status = "black", solidHeader = TRUE, width = 12,
                 HTML('<p>12/04/25 Version 1.0.0beta of DrugSurvPlot released.</p>'
                 )
             )
           ),
           fluidRow(
             box(id = "FAQbox",
                 title = strong("FAQ", style = 'font-size:18px;color:white;'),
                 icon = icon("comments"),
                 collapsible = TRUE,
                 collapsed = FALSE,
                 status = "black", solidHeader = TRUE, width = 12,
                 HTML('<h5> <b>1. Why does the drugs I type in return no results?</b> </h5>',
                      '<p>The drugs we provided here mostly come from <a href="https://www.cancerrxgene.org/" target="_blank">GDSC2</a>. The whole list of drugs we provided can be found <a href="www/data/druglist.csv" download="druglist.csv">here</a>.</p>',
                      '<h5> <b>2. What are the full forms of the survival outcomes provided?</b> </h5>',
                      '<p>Altogether, there are 13 different survival outcomes available. Their abbreviations and corresponding full forms are shown below.</p>',
                      '<p> BCR: Biochemical Recurrence Free Survival</p>',
                      '<p> CSS: Cancer Specific Survival</p>',
                      '<p> DFI: Disease Free Interval</p>',
                      '<p> DFS: Disease Free Survival</p>',
                      '<p> DMFS: Distant Metastasis Free Survival</p>',
                      '<p> DRFS: Distant Relapse Free Survival</p>',
                      '<p> DSS: Disease Specific Survival</p>',
                      '<p> FFS: Failure Free Survival</p>',
                      '<p> MFS: Metastasis Free Survival</p>',
                      '<p> OS: Overall Survival</p>',
                      '<p> PFI: Progression Free Interval</p>',
                      '<p> PFS: Progression Free Survival</p>',
                      '<p> RFS: Recurrence Free Survival</p>',
                      '<h5> <b>3. Why is there no median survival line shown in the K-M plot I have made?</b> </h5>',
                      '<p> Because of the specific cutoff point you chose, the median survival has not yet been reached, and more than half of the patients are still alive.</p>'
                 )
             )
           )
  )
)