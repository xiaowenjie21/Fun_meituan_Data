
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

#test connection mysql
#con<-dbConnect(RMySQL::MySQL(), host = "192.168.1.249",user = "root", password = "root",dbname='meituan_comment')

library(shiny)
library(stringr)
library(RMySQL)
library(rCharts)
library(DT)

con<-getConnection()

shinyServer(function(input, output) {
 
  randomVals <- eventReactive(input$go, {
    
    #keyword=iconv(input$key,'utf8','gbk')
    dbSendQuery(con,'SET NAMES gbk')
    query_sql<-str_c("select * from comShop_all_data where food_name like N'%",input$key,"%'")
    print(query_sql)
    res<-dbSendQuery(con,query_sql)
    print(res)
    data<-data.frame(dbFetch(res))
    print(data)
    return(data)
    dbDisconnect(con)
    })
  
  randomVals2 <- eventReactive(input$go2, {
    
    #keyword=iconv(input$key,'utf8','gbk')
    dbSendQuery(con,'SET NAMES gbk')
    query_sql<-str_c("select * from comShop_all_data where food_name like N'%",input$key,"%'")
    print(query_sql)
    res<-dbSendQuery(con,query_sql)
    print(res)
    data<-data.frame(dbFetch(res))
    print(data)
    return(data)
    dbDisconnect(con)
  })
  
  
  randomVals3 <- eventReactive(input$go3, {
    
    dbSendQuery(con,'SET NAMES gbk')
    #查询语句
    query_sql<-str_c("select shopname,price from comShop_all_data where food_name like N'%",input$key,"%'")
    res<-dbSendQuery(con,query_sql)
    data<-data.frame(dbFetch(res))
    #数据处理
    price<-str_split_fixed(data$price,'#',n = 2)[,1]
    newdata<-data.frame(cbind(data$shopname,price))
    names(newdata)<-c('shopname','price')
    newdata$price<-as.numeric(as.character(newdata$price))
    newdata$shop<-as.character(newdata$shop)
    return(newdata)
    dbDisconnect(con)
  })
  
  
  
  datadownload <- reactive({
    dbSendQuery(con,'SET NAMES gbk')
    
    query_sql<-str_c("select * from comShop_all_data where food_name like N'%",input$key,"%'")
    print(query_sql)
    res<-dbSendQuery(con,query_sql)
    print(res)
    data<-data.frame(dbFetch(res))
    print(data)
    return(data)
    dbDisconnect(con)
  })
 
  output$downloadData <- downloadHandler(
    filename = function() {
      paste('data-', Sys.Date(), '.csv', sep='')
    },
    content = function(file) {
      write.csv(datadownload(), file)
    }
  )
  
  
  #可视化图表
  
  output$myChart <- renderChart({
     
    #if (input$go3 == 0)
      #return()
    
    newdata<-randomVals3()
    
    p1 <- hPlot(price~shopname,data = newdata,type = c('column', 'line'),title = '店铺与价格分布图',subtitle = '鼠标指向查看数据点')
    p1$xAxis(labels = list(rotation = -45, align = 'right', style = list(fontSize = '16px', fontFamily = '华文细黑')), replace = F)
    #p1$plotOptions(bar = list(cursor = 'pointer', point = list(events = list(click = "#! function() { alert ('Category: '+ this.category +', value: '+ this.y); } !#"))))
    p1$chart(zoomType = "xy")
    p1$exporting(enabled = T)
    p1$colors('rgba(30, 144,255, 1)', 'rgba(30, 144,255, 1)', 'rgba(30, 144, 255, 1)')
    p1$legend(align = 'right', verticalAlign = 'top', layout = 'vertical')
    p1$tooltip(formatter = "#! function() { return '店名：'+this.x + ', 价格：' + this.y; } !#")
    p1$addParams(dom = 'myChart')
    return(p1)
    
  })
  
  
  output$htmloutput<-renderText({
    
    if (input$go == 0)
      return()
    
    newdata<-randomVals()
    comment<-str_split(unlist(str_replace_all(newdata$comment,' ','')),'#')[[1]]
   
    paste0("
           <tr class='show'>
           <td width=250px height=250px><img src='",newdata$food_jpg,"' width=250px height=250px  /></td>
           <td style='color:purple'><a href='",newdata$url,"'>",newdata$shopname,"</a></td>
           <td>",newdata$address,"</td>
    
           <td>",newdata$phone,"</td>
           <td>",newdata$food_name,"</td>
           <td>",comment,"</td>
           </tr>
           ")
 
  })
  
  #DT数据
  
    observe({
      
    if (input$go2 == 0)
      return()
      
    newdata<-randomVals2()
    newdata$comment<-NULL
    output$DT<-DT::renderDataTable(newdata, options = list(lengthChange = FALSE))
    })
    

}
)


