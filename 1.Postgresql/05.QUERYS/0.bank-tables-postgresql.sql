-- Create the account_master table
CREATE TABLE account_master (
    account_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(20) NOT NULL CHECK (account_type IN ('Savings', 'Current', 'Fixed Deposit', 'Loan', 'Recurring Deposit')),
    account_number VARCHAR(16) UNIQUE NOT NULL,
    branch_name VARCHAR(50) NOT NULL,
    open_date DATE NOT NULL,
    account_balance DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    account_status VARCHAR(10) NOT NULL CHECK (account_status IN ('Active', 'Inactive', 'Closed')),
    phone_number VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the transaction table
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    account_id INTEGER NOT NULL REFERENCES account_master(account_id),
    transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('Deposit', 'Withdrawal', 'Transfer', 'ATM', 'Interest', 'Fee')),
    transaction_amount DECIMAL(12, 2) NOT NULL,
    transaction_description TEXT,
    transaction_status VARCHAR(20) NOT NULL CHECK (transaction_status IN ('Completed', 'Pending', 'Failed', 'Reversed')),
    reference_number VARCHAR(50),
    counter_party_account VARCHAR(16),
    counter_party_name VARCHAR(100),
    balance_after_transaction DECIMAL(12, 2) NOT NULL
);

DROP table transactions
DROP table account_master
select * from account_master
select * from transactions
	
-- Insert sample data into account_master (20 customers)
INSERT INTO account_master (customer_id, customer_name, account_type, account_number, branch_name, open_date, account_balance, account_status, phone_number, email, address)
VALUES
    (1001, 'Thillai Shanmugam', 'Savings', '1001456789012345', 'Downtown Branch', '2022-01-10', 5420.50, 'Active', '555-123-4567', 'thillai.s@email.com', '123 Main St, Anytown'),
    (1002, 'Tamizhvani', 'Current', '1002456789012345', 'Central Branch', '2022-02-15', 12750.75, 'Active', '555-234-5678', 'tamizhvani@email.com', '456 Oak Ave, Somewhere'),
    (1003, 'Abinaya', 'Savings', '1003456789012345', 'Westside Branch', '2022-03-20', 3245.25, 'Active', '555-345-6789', 'abinaya@email.com', '789 Pine St, Elsewhere'),
    (1004, 'Dharshini', 'Fixed Deposit', '1004456789012345', 'Downtown Branch', '2022-04-05', 25000.00, 'Active', '555-456-7890', 'dharshini@email.com', '101 Elm Rd, Nowhere'),
    (1005, 'Karpagam', 'Current', '1005456789012345', 'Central Branch', '2022-05-12', 8356.50, 'Active', '555-567-8901', 'karpagam@email.com', '202 Maple Dr, Anywhere'),
    (1006, 'Rajeshwari', 'Savings', '1006456789012345', 'Eastside Branch', '2022-06-18', 4210.75, 'Active', '555-678-9012', 'rajeshwari@email.com', '303 Cedar Ln, Somewhere'),
    (1007, 'Senthil', 'Loan', '1007456789012345', 'Downtown Branch', '2022-07-22', -15000.00, 'Active', '555-789-0123', 'senthil@email.com', '404 Birch Blvd, Elsewhere'),
    (1008, 'Sathish', 'Recurring Deposit', '1008456789012345', 'Westside Branch', '2022-08-30', 7500.00, 'Active', '555-890-1234', 'sathish@email.com', '505 Willow Way, Nowhere'),
    (1009, 'Dhanabal', 'Savings', '1009456789012345', 'Central Branch', '2022-09-05', 2890.25, 'Active', '555-901-2345', 'dhanabal@email.com', '606 Spruce St, Anywhere'),
    (1010, 'Vasugi', 'Current', '1010456789012345', 'Eastside Branch', '2022-10-12', 9845.50, 'Active', '555-012-3456', 'vasugi@email.com', '707 Ash Ave, Somewhere'),
    (1011, 'Rohit', 'Fixed Deposit', '1011456789012345', 'Downtown Branch', '2022-11-20', 30000.00, 'Active', '555-123-4568', 'rohit@email.com', '808 Alder Rd, Elsewhere'),
    (1012, 'Inban', 'Savings', '1012456789012345', 'Westside Branch', '2022-12-05', 6750.25, 'Active', '555-234-5679', 'inban@email.com', '909 Poplar Dr, Nowhere'),
    (1013, 'Iyal', 'Current', '1013456789012345', 'Central Branch', '2023-01-15', 11240.75, 'Active', '555-345-6780', 'iyal@email.com', '110 Hemlock Ln, Anywhere'),
    (1014, 'Mithran', 'Loan', '1014456789012345', 'Eastside Branch', '2023-02-22', -25000.00, 'Active', '555-456-7891', 'mithran@email.com', '111 Fir Blvd, Somewhere'),
    (1015, 'Aadhi', 'Savings', '1015456789012345', 'Downtown Branch', '2023-03-10', 3175.50, 'Active', '555-567-8902', 'aadhi@email.com', '112 Pine St, Elsewhere'),
    (1016, 'Samera', 'Recurring Deposit', '1016456789012345', 'Westside Branch', '2023-04-18', 8500.00, 'Active', '555-678-9013', 'samera@email.com', '113 Cedar Ave, Nowhere'),
    (1017, 'Tamizillai', 'Savings', '1017456789012345', 'Central Branch', '2023-05-25', 4820.25, 'Inactive', '555-789-0124', 'tamizillai@email.com', '114 Elm Rd, Anywhere'),
    (1018, 'Karthik', 'Current', '1018456789012345', 'Eastside Branch', '2023-06-02', 240.50, 'Active', '555-890-1235', 'karthik@email.com', '115 Oak Dr, Somewhere'),
    (1019, 'Bala', 'Fixed Deposit', '1019456789012345', 'Downtown Branch', '2023-07-10', 15000.00, 'Closed', '555-901-2346', 'bala@email.com', '116 Maple Ln, Elsewhere'),
    (1020, 'Priya', 'Savings', '1020456789012345', 'Westside Branch', '2023-08-17', 7320.75, 'Active', '555-012-3457', 'priya@email.com', '117 Birch St, Nowhere');

-- Insert sample transactions (50 records)
INSERT INTO transactions (account_id, transaction_date, transaction_type, transaction_amount, transaction_description, transaction_status, reference_number, counter_party_account, counter_party_name, balance_after_transaction)
VALUES
    -- Thillai Shanmugam transactions
    (1, '2023-09-01 09:15:00', 'Deposit', 1000.00, 'Salary deposit', 'Completed', 'REF001', NULL, 'Employer Inc', 6420.50),
    (1, '2023-09-03 14:30:00', 'ATM', 200.00, 'ATM withdrawal', 'Completed', 'ATM001', NULL, NULL, 6220.50),
    (1, '2023-09-05 10:45:00', 'Transfer', 300.00, 'Transfer to Tamizhvani', 'Completed', 'TRF001', '1002456789012345', 'Tamizhvani', 5920.50),
    (1, '2023-09-10 16:20:00', 'Withdrawal', 500.00, 'Counter withdrawal', 'Completed', 'WDL001', NULL, NULL, 5420.50),
    
    -- Tamizhvani transactions
    (2, '2023-09-02 11:00:00', 'Deposit', 2500.00, 'Client payment', 'Completed', 'REF002', NULL, 'Client Co', 15250.75),
    (2, '2023-09-05 10:45:00', 'Transfer', 300.00, 'Transfer from Thillai', 'Completed', 'TRF001', '1001456789012345', 'Thillai Shanmugam', 15550.75),
    (2, '2023-09-08 09:30:00', 'ATM', 1000.00, 'ATM withdrawal', 'Completed', 'ATM002', NULL, NULL, 14550.75),
    (2, '2023-09-12 15:15:00', 'Transfer', 1800.00, 'Rent payment', 'Completed', 'TRF002', '1010456789012345', 'Vasugi', 12750.75),
    
    -- Abinaya transactions
    (3, '2023-09-01 13:30:00', 'Deposit', 1200.00, 'Salary deposit', 'Completed', 'REF003', NULL, 'Employer Inc', 4445.25),
    (3, '2023-09-04 14:00:00', 'Fee', 25.00, 'Monthly service fee', 'Completed', 'FEE001', NULL, 'Bank', 4420.25),
    (3, '2023-09-09 16:45:00', 'ATM', 500.00, 'ATM withdrawal', 'Completed', 'ATM003', NULL, NULL, 3920.25),
    (3, '2023-09-15 11:20:00', 'Transfer', 675.00, 'Utility payment', 'Completed', 'TRF003', '1013456789012345', 'Utility Co', 3245.25),
    
    -- Dharshini transactions
    (4, '2023-09-05 09:00:00', 'Interest', 250.00, 'Interest earned', 'Completed', 'INT001', NULL, 'Bank', 25250.00),
    (4, '2023-09-20 10:30:00', 'Withdrawal', 250.00, 'Counter withdrawal', 'Completed', 'WDL002', NULL, NULL, 25000.00),
    
    -- Karpagam transactions
    (5, '2023-09-01 10:00:00', 'Deposit', 3000.00, 'Salary deposit', 'Completed', 'REF004', NULL, 'Employer Inc', 11356.50),
    (5, '2023-09-06 15:45:00', 'Transfer', 1500.00, 'Car payment', 'Completed', 'TRF004', '1014456789012345', 'Car Finance Co', 9856.50),
    (5, '2023-09-11 09:15:00', 'ATM', 1000.00, 'ATM withdrawal', 'Completed', 'ATM004', NULL, NULL, 8856.50),
    (5, '2023-09-18 14:30:00', 'Fee', 500.00, 'Overdraft fee', 'Completed', 'FEE002', NULL, 'Bank', 8356.50),
    
    -- Rajeshwari transactions
    (6, '2023-09-02 13:00:00', 'Deposit', 1500.00, 'Salary deposit', 'Completed', 'REF005', NULL, 'Employer Inc', 5710.75),
    (6, '2023-09-07 11:30:00', 'ATM', 300.00, 'ATM withdrawal', 'Completed', 'ATM005', NULL, NULL, 5410.75),
    (6, '2023-09-14 16:00:00', 'Transfer', 1200.00, 'Rent payment', 'Completed', 'TRF005', '1010456789012345', 'Vasugi', 4210.75),
    
    -- Senthil transactions
    (7, '2023-09-01 14:45:00', 'Transfer', 1000.00, 'Loan payment', 'Completed', 'TRF006', NULL, 'Bank', -14000.00),
    (7, '2023-09-15 09:30:00', 'Fee', 50.00, 'Late payment fee', 'Completed', 'FEE003', NULL, 'Bank', -14050.00),
    (7, '2023-09-25 10:15:00', 'Transfer', 950.00, 'Loan payment', 'Completed', 'TRF007', NULL, 'Bank', -15000.00),
    
    -- Sathish transactions
    (8, '2023-09-01 08:45:00', 'Deposit', 500.00, 'Monthly deposit', 'Completed', 'REF006', NULL, NULL, 8000.00),
    (8, '2023-09-10 15:30:00', 'Interest', 75.00, 'Interest earned', 'Completed', 'INT002', NULL, 'Bank', 8075.00),
    (8, '2023-09-20 09:00:00', 'Withdrawal', 575.00, 'Counter withdrawal', 'Completed', 'WDL003', NULL, NULL, 7500.00),
    
    -- Dhanabal transactions
    (9, '2023-09-01 11:15:00', 'Deposit', 1200.00, 'Salary deposit', 'Completed', 'REF007', NULL, 'Employer Inc', 4090.25),
    (9, '2023-09-08 14:00:00', 'ATM', 500.00, 'ATM withdrawal', 'Completed', 'ATM006', NULL, NULL, 3590.25),
    (9, '2023-09-16 10:30:00', 'Transfer', 700.00, 'Utility payment', 'Completed', 'TRF008', '1013456789012345', 'Utility Co', 2890.25),
    
    -- Vasugi transactions
    (10, '2023-09-02 09:45:00', 'Deposit', 3000.00, 'Business income', 'Completed', 'REF008', NULL, 'Business Inc', 12845.50),
    (10, '2023-09-12 15:15:00', 'Transfer', 1800.00, 'Rent received', 'Completed', 'TRF002', '1002456789012345', 'Tamizhvani', 14645.50),
    (10, '2023-09-14 16:00:00', 'Transfer', 1200.00, 'Rent received', 'Completed', 'TRF005', '1006456789012345', 'Rajeshwari', 15845.50),
    (10, '2023-09-20 13:30:00', 'ATM', 2000.00, 'ATM withdrawal', 'Completed', 'ATM007', NULL, NULL, 13845.50),
    (10, '2023-09-25 11:00:00', 'Transfer', 4000.00, 'Supplier payment', 'Completed', 'TRF009', '1018456789012345', 'Supplier Co', 9845.50),
    
    -- Account 11 transactions (corrected row)
    (11, '2023-09-15 15:00:00', 'Interest', 300.00, 'Interest earned', 'Completed', 'INT003', NULL, 'Bank', 30300.00),
    (11, '2023-09-30 10:30:00', 'Withdrawal', 300.00, 'Counter withdrawal', 'Completed', 'WDL004', NULL, NULL, 30000.00),
    
    -- Nancy White transactions
    (12, '2023-09-01 08:30:00', 'Deposit', 1500.00, 'Salary deposit', 'Completed', 'REF009', NULL, 'Employer Inc', 8250.25),
    (12, '2023-09-09 15:00:00', 'ATM', 800.00, 'ATM withdrawal', 'Completed', 'ATM008', NULL, NULL, 7450.25),
    (12, '2023-09-18 10:45:00', 'Transfer', 700.00, 'Credit card payment', 'Completed', 'TRF010', '1014456789012345', 'Credit Co', 6750.25),
    
    -- Steven Clark transactions
    (13, '2023-09-01 09:00:00', 'Deposit', 2500.00, 'Salary deposit', 'Completed', 'REF010', NULL, 'Employer Inc', 13740.75),
    (13, '2023-09-07 14:15:00', 'Transfer', 1500.00, 'Mortgage payment', 'Completed', 'TRF011', '1014456789012345', 'Mortgage Co', 12240.75),
    (13, '2023-09-15 11:30:00', 'Fee', 25.00, 'Monthly service fee', 'Completed', 'FEE004', NULL, 'Bank', 12215.75),
    (13, '2023-09-22 16:45:00', 'ATM', 975.00, 'ATM withdrawal', 'Completed', 'ATM009', NULL, NULL, 11240.75);