-- Drop Table expenses;
CREATE TABLE if not exists expenses (
    id SERIAL PRIMARY KEY,          -- Auto-incrementing primary key
    title VARCHAR(500) NOT NULL,          -- Ensure title cannot be NULL
    amount NUMERIC(10, 2) NOT NULL ,  -- Precise monetary values and must be positive
    category VARCHAR(30) NOT NULL,       -- Ensure category cannot be NULL
    dates VARCHAR(30) NOT NULL           -- Ensure dates cannot be NULL -- Optional: Add a timestamp for when the record is created
);

-- -- insert into expenses( title , amount, category, dates) values('title' , 10.0, 'BILLS', '12-21-2024');
SELECT id, title, amount, category, dates FROM expenses;