# 🏗️ Medallion Architecture — Modern Data Engineering Project

> **Production-grade Lakehouse implementation on Azure using Azure Databricks, dbt, Unity Catalog, and Azure Data Factory**

---

## 📌 Project Overview

This project implements a complete **Medallion Architecture** (Bronze → Silver → Gold) on Microsoft Azure. It demonstrates end-to-end modern data platform capabilities including:

- Raw data ingestion from Azure SQL Database
- Governed data lakehouse using **Unity Catalog**
- Slowly Changing Dimensions (SCD Type 2) using **dbt Snapshots**
- Dimensional modeling (Star Schema) using **dbt Models**
- Orchestration using **Azure Data Factory**
- Full governance, lineage, and documentation

**Goal:** Build a scalable, governed, and production-ready data platform that can serve analytics and BI workloads.

---

## 🏛️ Architecture

```
┌─────────────────────┐
│   Azure SQL DB      │  (Source - AdventureWorksLT / SalesLT)
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐     ┌──────────────────────────────┐
│  Azure Data Factory │────▶│  Bronze Layer (ADLS Gen2)    │
│   (Orchestration)   │     │  + Unity Catalog External    │
└─────────────────────┘     │  Tables (saleslt schema)     │
           │                └──────────────┬───────────────┘
           │                               │
           │                               ▼
           │                ┌──────────────────────────────┐
           │                │  Silver Layer (dbt Snapshots)│
           │                │  SCD Type 2 + ADLS Gen2      │
           │                └──────────────┬───────────────┘
           │                               │
           │                               ▼
           │                ┌──────────────────────────────┐
           │                │  Gold Layer (dbt Models)     │
           │                │  dim_customer, dim_product,  │
           │                │  sales (saleslt_gold schema) │
           │                └──────────────────────────────┘
           │
           ▼
┌─────────────────────┐
│  Unity Catalog      │  (Governance, Lineage, Access Control)
│  + dbt Documentation│
└─────────────────────┘
```

---

## 🛠️ Technology Stack

| Layer              | Technology                          | Purpose                              |
|--------------------|-------------------------------------|--------------------------------------|
| **Source**         | Azure SQL Database                  | Transactional source (AdventureWorksLT) |
| **Orchestration**  | Azure Data Factory                  | Pipeline orchestration + dynamic processing |
| **Bronze**         | ADLS Gen2 + Unity Catalog           | Raw Parquet storage + External tables |
| **Silver**         | dbt Snapshots                       | SCD Type 2 historical tracking       |
| **Gold**           | dbt Models (marts)                  | Dimensional modeling (Star Schema)   |
| **Governance**     | Unity Catalog                       | Catalog, schemas, access control, lineage |
| **Storage**        | Azure Data Lake Storage Gen2        | Bronze, Silver, Gold containers      |
| **Development**    | Databricks Notebooks + VS Code + dbt| Interactive development              |

---

## ✅ What Was Implemented

### 1. Pre-requisites (Unity Catalog Setup)
- Unity Catalog Metastore in Central India
- User-Assigned Managed Identity
- Access Connector for Azure Databricks
- Storage Credential with proper RBAC
- Catalog `medallion` with schemas: `saleslt`, `saleslt_gold`, `snapshots`

### 2. Bronze Layer
- Azure Data Factory pipeline with **Copy Activity** loads data from Azure SQL → ADLS Gen2 Bronze container (Parquet)
- **Notebook Activity** (triggered at end of pipeline) dynamically creates external tables in Unity Catalog under `saleslt` schema

### 3. Silver Layer (SCD Type 2)
- dbt project initialized and connected to Azure Databricks
- **10 dbt snapshots** created for historical tracking:
  - `address_snapshot`, `customer_snapshot`, `customeraddress_snapshot`
  - `product_snapshot`, `productcategory_snapshot`, `productdescription_snapshot`
  - `productmodel_snapshot`, `productmodelproductdescription_snapshot`
  - `salesorderdetail_snapshot`, `salesorderheader_snapshot`
- Snapshots stored in both Unity Catalog (`snapshots` schema) and ADLS Gen2 Silver container

### 4. Gold Layer (Dimensional Modeling)
- **3 dbt models** created in `marts`:
  - `dim_customer` (with surrogate key + data quality tests)
  - `dim_product`
  - `sales` (fact table)
- Models materialized in Unity Catalog under `saleslt_gold` schema
- Data also written to ADLS Gen2 Gold container

### 5. Orchestration
- Azure Data Factory pipeline (`medallion_pipeline`) with:
  - Lookup + ForEach + Append Variable (dynamic table list)
  - Copy Data activities
  - Databricks Notebook activity (dynamic external table creation)

### 6. Governance & Documentation
- Full Unity Catalog governance
- dbt documentation generated with lineage graph
- Column-level descriptions and test results

---

## 🔄 End-to-End Data Flow

1. **Pre-requisites** → Unity Catalog infrastructure setup
2. **Source Discovery** → Azure SQL Database tables identified
3. **Orchestration** → ADF Pipeline triggered
4. **Bronze Layer** → Data copied to ADLS Gen2 → Notebook creates external tables in Unity Catalog
5. **Silver Layer** → `dbt snapshot` creates SCD Type 2 tables
6. **Gold Layer** → `dbt run` creates dimensional models (`dim_customer`, `dim_product`, `sales`)
7. **Documentation** → `dbt docs generate` + final verification in Unity Catalog Explorer

---

## 📸 Key Evidence (Screenshots)

> All screenshots are included in the detailed notes document.

- Unity Catalog Metastore, Access Connector, Storage Credential setup
- ADF Pipeline with successful execution (24 activities)
- Bronze container with raw Parquet files
- Databricks Notebook creating external tables dynamically
- dbt snapshot run (10 snapshots completed successfully)
- dbt model run (3 Gold models created)
- Unity Catalog Explorer showing all schemas (`saleslt`, `saleslt_gold`, `snapshots`)
- dbt Documentation with lineage graph

---

## 🧠 Skills Demonstrated

- **Medallion / Lakehouse Architecture** design and implementation
- **Unity Catalog** governance, metastore setup, and access management
- **dbt** for snapshots (SCD Type 2), modeling, testing, and documentation
- **Azure Databricks + Spark** for large-scale data processing
- **Azure Data Factory** for complex orchestration and dynamic pipelines
- Infrastructure setup (Managed Identity, Access Connectors, Storage Credentials)
- End-to-end data platform development from source to analytics consumption
- Troubleshooting SSL, authentication, and dynamic pipeline issues

---

## 📁 Project Deliverables

| File | Description |
|------|-------------|
| `Medallion_Architecture_Final_Notes.docx` | Complete technical documentation with 19 figures/screenshots |
| `README_Medallion_Architecture.md` | This file (high-level project summary) |

---

## 🚀 How to Reproduce (High Level)

1. **Setup Unity Catalog**
   - Create Metastore, Managed Identity, Access Connector, Storage Credential
   - Create Catalog `medallion` with required schemas

2. **Prepare Source**
   - Deploy AdventureWorksLT sample database on Azure SQL

3. **Create ADF Pipeline**
   - Build pipeline with Lookup + ForEach + Copy + Notebook activities
   - Configure Databricks linked service using Personal Access Token

4. **Initialize dbt Project**
   - Initialize dbt project with Databricks adapter
   - Configure `dbt_project.yml`, sources, snapshots, and models
   - Export SSL certificates (if running on macOS)

5. **Execute Pipeline**
   - Run ADF pipeline → Bronze layer created
   - Run `dbt snapshot` → Silver layer created
   - Run `dbt run` → Gold layer created
   - Run `dbt docs generate` → Documentation created

---

## 🏆 Key Achievements

- ✅ Full end-to-end Medallion Architecture on Azure
- ✅ Proper Unity Catalog governance implemented from day one
- ✅ 10 SCD Type 2 snapshots successfully implemented
- ✅ Clean dimensional model in Gold layer with surrogate keys and tests
- ✅ Dynamic ADF + Databricks Notebook integration
- ✅ Complete documentation and lineage using dbt + Unity Catalog

---

## 📝 Notes

This project was built as a **portfolio piece** to demonstrate modern data engineering capabilities on Azure. It follows best practices for governance, scalability, and maintainability.

For detailed implementation steps, screenshots, code snippets, and troubleshooting, refer to the accompanying **Medallion_Architecture_Final_Notes.docx**.

---

**Author:** Himanshu
**Focus Areas:** Azure Data Engineering, Databricks, dbt, Unity Catalog, ADF

---
