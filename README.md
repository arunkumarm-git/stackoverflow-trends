🎯 Project Overview
This project provides a complete analytical framework for understanding StackOverflow question dynamics using data from BigQuery's StackOverflow public dataset.

```mermaid
graph LR
    %% Styles
    classDef source fill:#e1f5fe,stroke:#01579b,stroke-width:2px;
    classDef dbt fill:#fff3e0,stroke:#e65100,stroke-width:2px;
    classDef storage fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px;
    classDef viz fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px;

    subgraph Google_Cloud_Platform ["☁️ Google Cloud Platform (BigQuery)"]
        direction TB
        
        subgraph Source_Data ["1. Extraction"]
            RawData[("posts_questions<br>(Public Dataset)")]:::source
        end

        subgraph Transformation ["2. Transformation (dbt)"]
            direction TB
            Staging("stg_questions<br>(Cleaning & Sampling)<br>Filter: 2019-2022"):::dbt
            
            subgraph Star_Schema ["Star Schema Construction"]
                DimDate("dim_date<br>(Date Dimension)"):::dbt
                FactTable("fct_tag_trends<br>(Fact Table)<br>Unnested Tags"):::dbt
            end
        end

        subgraph Final_Storage ["3. Storage (User Dataset)"]
            Final_Dim[("dim_date<br>Materialized Table")]:::storage
            Final_Fct[("fct_tag_trends<br>Materialized Table<br>PARTITION: By Day<br>CLUSTER: By Tag")]:::storage
        end
    end

    subgraph Visualization ["4. Visualization"]
        PowerBI("Power BI Dashboard<br>(StackOverFlow.pbix)"):::viz
    end

    %% Relationships
    RawData --> Staging
    Staging --> DimDate
    Staging --> FactTable
    
    %% Materialization Flow
    DimDate -.-> Final_Dim
    FactTable -.-> Final_Fct

    %% Power BI Connections
    Final_Dim ==> PowerBI
    Final_Fct ==> PowerBI
    ```