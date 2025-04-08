-- Criação do banco de dados
-- drop database company_db;
CREATE DATABASE company_db;
USE company_db;

-- Tabela de Departamentos
CREATE TABLE department (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

-- Tabela de Empregados
CREATE TABLE employee (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    salary FLOAT NOT NULL,
    department_id INT,
    is_manager BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (department_id) REFERENCES department(id)
);

-- Tabela de Projetos
CREATE TABLE project (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    department_id INT,

    FOREIGN KEY (department_id) REFERENCES department(id)
);

-- Relacionamento N:N entre employee e project
CREATE TABLE employee_project (
    employee_id INT,
    project_id INT,
    hours_allocated INT,

    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id) REFERENCES employee(id),
    FOREIGN KEY (project_id) REFERENCES project(id)
);

-- Dependentes dos empregados
CREATE TABLE dependent (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    name VARCHAR(100),
    relationship VARCHAR(50),

    FOREIGN KEY (employee_id) REFERENCES employee(id)
);

DELIMITER $$
CREATE TRIGGER trg_before_update_salary
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    IF NEW.salary < 1000 THEN
        SET NEW.salary = 1000;
    END IF;
END $$
DELIMITER ;

-- tabela de backup
CREATE TABLE IF NOT EXISTS employee_backup (
    id INT,
    fname VARCHAR(50),
    lname VARCHAR(50),
    salary FLOAT,
    department_id INT,
    is_manager BOOLEAN,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- gatilho BEFORE DELETE
DELIMITER $$
CREATE TRIGGER trg_before_delete_employee
BEFORE DELETE ON employee
FOR EACH ROW
BEGIN
    INSERT INTO employee_backup (id, fname, lname, salary, department_id, is_manager)
    VALUES (OLD.id, OLD.fname, OLD.lname, OLD.salary, OLD.department_id, OLD.is_manager);
END $$
DELIMITER ;

-- projeto 4.2
use company_db;

-- Número de empregados por departamento e localidade
CREATE VIEW vw_emp_por_departamento_local AS
SELECT 
    d.name AS department,
    d.location,
    COUNT(e.id) AS total_employees
FROM 
    employee e
JOIN 
    department d ON e.department_id = d.id
GROUP BY 
    d.name, d.location;

-- Lista de departamentos e seus gerentes
CREATE VIEW vw_departamentos_gerentes AS
SELECT 
    d.name AS department,
    e.fname AS manager_fname,
    e.lname AS manager_lname
FROM 
    department d
JOIN 
    employee e ON d.id = e.department_id
WHERE 
    e.is_manager = TRUE;

-- Projetos com maior número de empregados (ordenado desc)
CREATE VIEW vw_projetos_mais_funcionarios AS
SELECT 
    p.name AS project,
    COUNT(ep.employee_id) AS total_employees
FROM 
    project p
JOIN 
    employee_project ep ON p.id = ep.project_id
GROUP BY 
    p.name
ORDER BY 
    total_employees DESC;

-- Lista de projetos, departamentos e gerentes
CREATE VIEW vw_proj_depart_gerentes AS
SELECT 
    p.name AS project,
    d.name AS department,
    e.fname AS manager_fname,
    e.lname AS manager_lname
FROM 
    project p
JOIN 
    department d ON p.department_id = d.id
JOIN 
    employee e ON d.id = e.department_id
WHERE 
    e.is_manager = TRUE;

-- Empregados com dependentes e se são gerentes
CREATE VIEW vw_emp_dependentes_gerentes AS
SELECT 
    e.fname,
    e.lname,
    e.is_manager,
    COUNT(d.id) AS total_dependents
FROM 
    employee e
LEFT JOIN 
    dependent d ON e.id = d.employee_id
GROUP BY 
    e.id;
