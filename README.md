🎯 Project Overview
This project provides a complete analytical framework for understanding StackOverflow question dynamics using data from BigQuery's StackOverflow public dataset. The solution combines Power BI's visualization capabilities with Python's analytical power to deliver actionable insights about question performance, community engagement, and temporal patterns.
🌟 Key Features

60+ Pre-built Measures - Comprehensive metrics covering all aspects of question analysis
5 Dashboard Pages - Organized by analytical perspective (Executive, Performance, Temporal, Tags, Quality)
Python-Powered Analytics - Flexible calculation engine using pandas and numpy
Interactive Visualizations - Dynamic filtering and drill-through capabilities
Production-Ready Code - Error handling, documentation, and best practices included


📁 Project Structure
stackoverflow-analysis/
│
├── src/
│   ├── stackoverflow_measures.py      # Main measures calculation class
│   └── visualization_helpers.py       # Helper functions for charts
│
├── powerbi/
│   ├── StackOverflow_Dashboard.pbix   # Power BI dashboard file
│   └── python_scripts/                # Individual Python visual scripts
│       ├── executive_overview.py
│       ├── performance_analysis.py
│       ├── temporal_patterns.py
│       ├── tag_analysis.py
│       └── quality_engagement.py
│
├── data/
│   ├── schema.sql                     # Database schema
│   └── sample_data.csv                # Sample dataset for testing
│
├── docs/
│   ├── powerbi_integration_guide.md   # Detailed integration guide
│   ├── measures_documentation.md      # All measures explained
│   └── dashboard_design.md            # Design principles and page layouts
│
├── examples/
│   ├── jupyter_notebooks/             # Example analyses in Jupyter
│   └── screenshots/                   # Dashboard screenshots
│
├── requirements.txt                   # Python dependencies
├── setup.py                          # Package installation script
├── README.md                         # This file
└── LICENSE                           # MIT License

🗃️ Data Model
The project uses a star schema with the following tables:
Fact Table: tbl_fact_questions
ColumnTypeDescriptionsurrogate_keyVARCHARUnique question identifierdate_keyINTForeign key to date dimensionanswer_countINTNumber of answers receivedanswer_statusVARCHARStatus (Accepted/Pending/None)comment_countINTNumber of commentsscoreINTQuestion score (upvotes - downvotes)tagVARCHARPrimary tagview_countINTTotal viewsfavorite_countINTTimes marked as favorite
Dimension Tables
tbl_date_dimension

date_key, creation_full_date, day_of_week, month, year

tbl_day_lookup

day_of_week, day_name

tbl_month_lookup

month, month_name, quarter


🚀 Getting Started
Prerequisites

Power BI Desktop (Latest version)
Python 3.8+
Required Python Packages:

bash  pip install pandas numpy matplotlib seaborn
Installation
1. Clone the Repository
bashgit clone https://github.com/yourusername/stackoverflow-analysis.git
cd stackoverflow-analysis
2. Install Python Dependencies
bashpip install -r requirements.txt
3. Configure Power BI Python Integration
Windows:
File → Options and Settings → Options → Python scripting
Set Python home directory (e.g., C:\Python38)
Mac:
Power BI Desktop → Preferences → Python scripting
Set Python home directory (e.g., /usr/local/bin/python3)
4. Load Your Data
Option A: BigQuery Direct Connection
sql-- Connect Power BI to BigQuery
-- Use this query to fetch data:
SELECT 
    id as surrogate_key,
    EXTRACT(DATE FROM creation_date) as creation_full_date,
    answer_count,
    comment_count,
    score,
    view_count,
    favorite_count,
    tags[OFFSET(0)] as tag
FROM `bigquery-public-data.stackoverflow.posts_questions`
WHERE creation_date >= '2020-01-01'
LIMIT 100000
Option B: Use Sample Data
bash# Import the sample CSV in Power BI
Get Data → Text/CSV → Select data/sample_data.csv
5. Open the Dashboard
Open powerbi/StackOverflow_Dashboard.pbix in Power BI Desktop