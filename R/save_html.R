library("htmltools")

save_html <- function(obj_shiny.tag, filePath="output.html"){
  
  obj_html_list = htmltools::renderTags(obj_shiny.tag)
  
  #print(class(obj_html_list))
  #print(names(obj_html_list))
  
  obj_html_raw = obj_html_list$html
  
  #print(class(obj_html_raw))
  #print(obj_html_raw)
  
  fileConn = file(filePath)
  writeLines(obj_html_raw, fileConn)
  close(fileConn)
  
}
