"""
-----------------
dataqualitychecks
-----------------

This module defines the actual logic of each data verification test.
This includes the raw SQL code used to query the database.

Tests are sorted into separate functions.
"""

from time import time, ctime

conn = None
def run_data_quality_check(**options):
    """Receive test parameters and run associated data quality test.
    
    This function serves to initialize a data quality test.
    This function receives a dictionary outlining which test to run
    and the parameters to use for said test. The correct test (function)
    is then called with the parameters passed to that function.
    
    Args:
        **options: Variable length keyword arguments passed in the form
            of a dictionary, which outlines the parameters for a
            data quality test. Variable length since each test has
            a varying number of required parameters.

    Returns:
        testname (str): Descriptive name given to the test.
        str: The database table targeted by the test.
        str: The database table column targeted by the test.
        status (bool): Whether the test passed (True) or not (False).
    """
    
    print("*" * 50)
    print(ctime(time()))
    start_time = time()
    testname = options.pop("testname")
    test = options.pop("test")
    print(f"Starting test {testname}")
    status = test(**options)
    print(f"Finished test {testname}")
    print(f"Test Passed {status}")
    end_time = time()
    options.pop("conn")
    print("Test Parameters")
    for key,value in options.items():
        print(f"{key} = {value}")
    print()
    print("Duration : ", str(end_time - start_time))
    print(ctime(time()))
    print("*" * 50)
    return testname,options.get('table'),options.get('column'),status

def check_for_nulls(column, table, conn=conn):
    """Check the column in the table for null values. 
    
    Args:
        column (str): The database table column to test for nulls.
        table (str): The targeted database table.
        conn (optional): The database connection instance. Defaults to conn.

    Returns:
        bool: True if no rows have nulls, False otherwise.
    """
    SQL=f'SELECT count(*) FROM "{table}" where {column} is null'
    cursor = conn.cursor()
    cursor.execute(SQL)
    row_count = cursor.fetchone()[0]
    cursor.close()
    return row_count == 0

def check_for_min_max(column, table, minimum, maximum, conn=conn):
    """Check if values in the column lie outside a given max and min value.

    Args:
        column (str): The database table column to test.
        table (str): The targeted database table.
        minimum (float): The maximum value of the bounded range to test.
        maximum (float): The minimum value of the bounded range to test.
        conn (optional): The database connection instance. Defaults to conn.

    Returns:
        bool: True if no values are outside the range, False otherwise.
    """
    SQL=f'SELECT count(*) FROM "{table}" where  {column} < {minimum} or {column} > {maximum}'
    cursor = conn.cursor()
    cursor.execute(SQL)
    row_count = cursor.fetchone()
    cursor.close()
    return not bool(row_count[0])

def check_for_valid_values(column, table, valid_values=None, conn=conn):
    """Check the column in the table for valid values.
    
    Values are deemed valid if they are found in the passed set.

    Args:
        column (str): The database table column to test.
        table (str): The targeted database table.
        valid_values (set, optional): A set containing the values deemed
            valid for the database column. Actual values in the column
            are compared against this set. Defaults to None.
        conn (optional): The database connection instance. Defaults to conn.

    Returns:
        bool: True if all column values are found in the set, False otherwise.
    """
    SQL=f'SELECT distinct({column}) FROM "{table}"'
    cursor = conn.cursor()
    cursor.execute(SQL)
    result = cursor.fetchall()
    #print(result)
    actual_values = {x[0] for x in result}
    print(actual_values)
    status = [value in valid_values for value in actual_values]
    #print(status)
    cursor.close()
    return all(status)

def check_for_duplicates(column, table, conn=conn):
    """Check the column of question for duplicate values.

    Args:
        column (str): The database table column to test.
        table (str): The targeted database table.
        conn (optional): The database connection instance. Defaults to conn.

    Returns:
        bool: True if no duplicate values, False otherwise.
    """
    SQL=f'SELECT count({column}) FROM "{table}" group by {column} having count({column}) > 1'
    cursor = conn.cursor()
    cursor.execute(SQL)
    row_count = cursor.fetchone()
    #print(row_count)
    cursor.close()
    return not bool(row_count)

