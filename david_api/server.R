library(data.table)
library(RDAVIDWebService)
library(shiny)
library(ggplot2)
options(repos = BiocManager::repositories())
options(shiny.maxRequestSize=10*1024^2)

function(input, output) {
    
    pro_coExpress_genes <- reactive({
        tryCatch({
            
            pro_coExpress_genes <- read.csv(input$file1$datapath, header = TRUE, sep = "\t")$Ensembl.Gene.ID
            pro_coExpress_genes <- pro_coExpress_genes[pro_coExpress_genes!=""]
            
        },
        error = function(e) {
            stop(safeError(e))
        }
        )
        pro_coExpress_genes
    })
    
    seed_genes <- reactive({
        tryCatch({
            
            seed_genes <- read.csv(input$file2$datapath, header = TRUE, sep = "\t")$Ensembl.Gene.ID
            seed_genes <- seed_genes[seed_genes!=""]
            
        },
        error = function(e) {
            stop(safeError(e))
        }
        )
        seed_genes
    })
    
    result <- reactive({
        req(input$file1)
        req(input$file2)
        
        pro_coExpress_genes <- pro_coExpress_genes()
        fore_genes <- seed_genes()
        
        ngenes <- length(pro_coExpress_genes)
        if(0.05*ngenes > 1500){
            back_genes <- pro_coExpress_genes[1:1500]
        }else{
            back_genes <-  pro_coExpress_genes[1:floor(0.05*ngenes)]
        }
        
        david<-DAVIDWebService$new(email="rguinea@pucp.edu.pe", url="https://david.ncifcrf.gov/webservice/services/DAVIDWebService")
        FG <- addList(david, fore_genes, idType="ENSEMBL_GENE_ID", listName="isClass", listType="Gene")
        BG <- addList(david, back_genes, idType="ENSEMBL_GENE_ID", listName="all", listType="Background")

        FuncAnnotChart <- getFunctionalAnnotationChart(david)
        FuncAnnotClust <- getClusterReport(david)
        
        nclust <- length(FuncAnnotClust@cluster)
        
        nclust <- length(FuncAnnotClust@cluster)
        df_clust <- data.frame()
        
        for(i in 1:nclust) {
            buff <- data.frame(FuncAnnotClust@cluster[[i]])
            buff$cluster <- paste("Cluster", i)
            df_clust <- rbind(df_clust, buff)
        }
        
        df_clust <- df_clust[2:ncol(df_clust)]
        for(i in 1:length(names(df_clust))) names(df_clust)[i] <- gsub("Members.", "", names(df_clust)[i])
        result <- data.frame(cluster = df_clust$cluster, annotation_cluster = df_clust$Category, enrichment_score = df_clust$Term, 
                             count = df_clust$Count, pvalue = df_clust$PValue, list_total = df_clust$List.Total, pop_hits = df_clust$Pop.Hits,
                             pop_total= df_clust$Pop.Total, fold_enrichment = df_clust$Fold.Enrichment, bonferroni = df_clust$Bonferroni, 
                             benjamini = df_clust$Benjamini, FDR = df_clust$FDR)
        
        result
        
    })
    
    # Filter data based on selections
    output$table <- DT::renderDataTable(DT::datatable({
        req(result())
        
        data <- result()
        if (input$cluster != "All") {
            data <- data[data$cluster == input$cluster,]
        }
        data
    }))
    
}
