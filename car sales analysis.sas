/*                               Car Sales Analysis */

/* Step 1: Data Importing */
PROC IMPORT DATAFILE='/home/u63925012/sasuser.v94/basic SAS program/car_sales.csv'
    OUT=work.car_data
    DBMS=CSV
    REPLACE;
    GETNAMES=YES;
    DATAROW=2;
RUN;

PROC PRINT data = work.car_data;
RUN;

/* Step 2: Data Cleaning */

/* Check for missing values */
proc means data=car_data n nmiss mean std min max;
run;

proc freq data=car_data;
    tables _all_ / missing;
run;

/* Impute missing values or remove rows with missing values */
data car_data_clean;
    set car_data;
    if missing(Sales_in_thousands) then Sales_in_thousands = 0;
    if missing(__year_resale_value) then __year_resale_value = 0;
run;

/* Step 3: Data Exploration */

/* Summary statistics */
proc means data=car_data_clean mean std min max;
    var Sales_in_thousands Price_in_thousands Horsepower;
run;

/* Correlation analysis */
proc corr data=car_data_clean;
    var Sales_in_thousands Price_in_thousands Horsepower;
run;

/* Scatter plot matrix */
proc sgscatter data=car_data_clean;
    matrix Sales_in_thousands Price_in_thousands Horsepower / diagonal=(histogram);
run;

/* Step 4: Data Visualization */

/* Bar chart for sales by manufacturer */
proc sgplot data=car_data_clean;
    vbar Manufacturer / response=Sales_in_thousands;
    title "Sales by Manufacturer";
run;

/* Box plot for price distribution by vehicle type */
proc sgplot data=car_data_clean;
    vbox Price_in_thousands / category=Vehicle_type;
    title "Price Distribution by Vehicle Type";
run;

/* Step 5: Advanced Analysis */

/* Linear regression analysis */
proc reg data=car_data_clean;
    model Sales_in_thousands = Price_in_thousands Horsepower Engine_size;
    title "Regression Analysis: Sales vs. Price, Horsepower, Engine Size";
run;

/* Step 6: Additional Data Analysis using PROC SQL */

/* Average sales, price, and horsepower by manufacturer */
proc sql;
    select Manufacturer, 
           mean(Sales_in_thousands) as Avg_Sales,
           mean(Price_in_thousands) as Avg_Price,
           mean(Horsepower) as Avg_Horsepower
    from car_data_clean
    group by Manufacturer;
quit;

/* Average sales by vehicle type */
proc sql;
    select Vehicle_type, 
           mean(Sales_in_thousands) as Avg_Sales
    from car_data_clean
    group by Vehicle_type;
quit;

/* Step 7: Save and Share Results */

/* Export to Excel */
proc export data=car_data_clean
    outfile='/home/u63925012/sasuser.v94/basic SAS program/clean_car_data.xlsx'
    dbms=xlsx
    replace;
run;


