library(shiny)
library(mirtCAT)
options(stringsAsFactors = FALSE)

# importar datos de un solo archivo
items_df<- readRDS("data-df.rds")
n_row<-nrow(items_df)

# genera un vector preguntas a partir de la tabla leida
## Options for each item
options <- matrix(c(items_df$Option.1, items_df$Option.2, items_df$Option.3,items_df$Option.4, items_df$Option.5),
                  nrow = n_row, ncol = 5)

# genera un vector preguntas a partir de la tabla leida
questions<-c(items_df$Question)

#guarda la tabla con las preguntas y las opciones
df <- data.frame(Question = questions, Option = options, Type = "radio")


SubID = createSessionName(n = 4, datetime = FALSE)

Fecha = date()

demographics <- list(textInput(inputId = 'ID',
                               label = 'ID asignado',
                               value = SubID),

                     textInput(inputId = 'Fecha',
                              label = 'Fecha',
                               value = Fecha),
                      textInput(inputId = 'comentario',
                               label = 'Quiere dejar algun comentario particular?',
                               value = ''),

                     selectInput(inputId = 'edad',
                                 label = 'Indica tu edad.',
                                 choices = c('', '19', '20', '21','22','23','24','25','26','27','28','29','30','+de 30'),
                                 selected = ''),

                     selectInput(inputId = 'gender',
                                 label = 'Indica tu género.',
                                 choices = c('', 'Mujer', 'Hombre', 'Otro'),
                                 selected = ''))


# css mod ('Readable' file downloaded from http://bootswatch.com/)
css <- readLines('bootstrap_3.css') # nolint

###(CAMBIAR) change aesthetics of GUI, including title, authors, header, and initial message
title <- "Encuesta Posgrado"
authors <- "Facultad de Derecho y Ciencias Sociales "

firstpage<- list(h2("Encuesta"), h5("Trata de responder la encuesta.\n
                                         Tomate tu tiempo y responde a con atenció,\n
                                         Tus respuesta nos permiten mejorar!"))

lastpage <- function(person){
  list(h1("Gracias por su respuesta")) 
}


library(shinythemes)

shinyGUI_list <- list(title = title, authors = authors, demographics = demographics,
                  demographics_inputIDs = c('ID','edad','Fecha','gender','comentario'), firstpage= firstpage, lastpage = lastpage, css = css)

#c('ID','Fecha','edad','gender')

# muestra las opciones de respuesta en forma horizontal
df$inline <- TRUE







#genera la interface GUI mirtCAT CUSTOMIZADA y guarda resultados se pisan al repetir

final_fun <- function(person){
time <- paste0('/srv/shiny-server/shared/', gsub(' ', '_', as.character(Sys.time())), '.rds')
saveRDS(person, time)
}



# resume test this way if test was stopped early (and temp files were saved)
mirtCAT_preamble(df = df, final_fun = final_fun, shinyGUI = shinyGUI_list)



# this must be the last line (implicitly wrapped in runApp() by shinyserver)
createShinyGUI(ui = NULL, host_server = TRUE)
