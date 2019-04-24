# Shape Shifting Buildings
Implementation of a Data Warehouse for a variety of buildings that can change their shapes based on external factors.

# Description
The Data Warehouse uses the Starnest Schema and constitutes of 5 tables.

### Schema

The starnest schema forms the integration of the star and snowflake schemas. It expresses naturally hierarchy levels by the clustering of data in nested tables, which results in the description of aggregation levels for a dimension in a natural way. This is achieved by nested dimension tables, since sub-attributes are inserted in a dimension in a nested way, where more detailed attributes are nested inside less detailed attributes. Therefore, dimension tables are not normalised. 
</br>
</br>
The logical representation of the DW consists of a central table (the fact table) and surrounding nested tables The fact table is linked to dimension tables with one-to-many relationships by foreign key attributes with a reference to the most detailed hierarchical attribute of each dimension (the most nested one). The nested approach would be adopted for the representation of functional dependencies in each dimension table; thus, a dimension’s hierarchy is represented as a nested table concerning the design of dimensions. 

### Tables

- 1 Fact table
- 2 Dimension tables
- 2 Nested tables

#### More specific:

###### Fact table 
- Name: Usage
- Rows: 10.000

###### 1st Dimension table 
- Name: Resident
- Rows: 1.000

###### 2st Dimension table 
- Name: Building
- Rows: 32

###### 1st Nested table (Inside of Building table)
- Name: Nt_Building_Features
- Rows: 32

###### 2st Nested table (Inside of Nt_Building_Features table)
- Name: Nt_Building_Shape
- Rows: 32

# Related Article
- [A house for ALL seasons](https://www.dailymail.co.uk/sciencetech/article-2840627/A-house-seasons-Shape-shifting-home-transforms-year-response-changing-temperatures.html).
- [Starnest Schema](https://www.researchgate.net/publication/262239999_Integrating_Star_and_Snowflake_Schemas_in_Data_Warehouses).
