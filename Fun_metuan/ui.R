library(shiny)
library(DT)
library(shinythemes)
library(rCharts)

packageCheck = unlist(packageVersion("shiny"))

if(packageCheck[1] == 0 & packageCheck[2] < 9){
  
  shinyOld = TRUE
} else {
  shinyOld = FALSE
}

shinyUI(pageWithSidebar(
  
  headerPanel(''),
  
  sidebarPanel(
    
    
    conditionalPanel(
      
    
      condition = "input.theTabs == 'Data_Display'",
      
      h3('外卖品牌预览'),
      h5('观测数据趋势，下载数据表格')
      
      
    ),
    
      textInput(inputId = 'key',label = '请输入想吃或想喝的东西',value='咖啡'),
      selectInput(inputId='area',label = '选择地区',choices = list('南山','宝安','罗湖')),
      helpText('店铺过少，暂时失灵'),
    
 
    conditionalPanel(
      
      condition = "input.theTabs == 'Charts'",

      selectInput("Statistics_Model", "请选择内置图表数据模型",list("店铺价格呈现"))
      
    ),
    
    conditionalPanel(
      
      
      condition = "input.theTabs == 'Data_Display'",
      downloadButton('downloadData','下载数据')
      
    ),
      
    conditionalPanel(
      
      condition = "input.theTabs == 'Data_Display'",
      
      actionButton("go", "开吃",icon = icon("refresh"))
      
      
    ),
    ###submitButton(text = 'Update Now')
    conditionalPanel(
      
      
      
      condition = "input.theTabs == 'Data_statistical'",
      
      actionButton("go2", "更新数据表",icon = icon("refresh"))
      
      
    ),
    conditionalPanel(
      
      
      
      condition = "input.theTabs == 'Charts'",
      
      actionButton("go3", "更新图表",icon = icon("refresh"))
      
      
    )
    
  ),
    

  mainPanel(
    
    tags$style(type="text/css", "body {padding-top: 50px;font-family:华文细黑}"),
    tags$style(type='text/css',".show td{padding:5px;text-align:center;margin:5px;vertical-align:middle}"),
    navbarPage("美团吃货联盟",position = 'fixed-top',inverse = TRUE,tabPanel('找一个地方吃东西',value='tongji',icon=icon('table')),id='nav',
               theme=shinytheme('cosmo'),
               tabsetPanel(id="theTabs",
                           tabPanel('数据展示' , htmlOutput('htmloutput'),value="Data_Display",icon = icon('file')),
                           tabPanel('数据表',DT::dataTableOutput('DT'),value="Data_statistical",icon=icon('th')),
                           #tabPanel('图表',showOutput("myChart","polycharts"),value='Charts',icon=icon('bar-chart'))
                           tabPanel('图表',showOutput('myChart',"highcharts"),value='Charts',icon=icon('bar-chart'))
               )
    )
  
  )
))

