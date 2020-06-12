/*--JOBS--*/

--Lista SCHEMAS 
select username as schema_name from sys.all_users order by username;

--Verificar SESSÕES BLOQUEADAS/BLOQUEADORAS na sua matrícula
select sid, serial#, osuser, machine from v$session where OSUSER = 'seu login aqui';

--ENCERRA SESSÃO
ALTER SYSTEM KILL SESSION 'numero_da_sid, numero_do_serial'; 


--Verifica que JOB ESTÁ EM EXECUÇÃO
SELECT 
    ENABLED, 
    OWNER, 
    STATE, 
    JOB_NAME, 
    START_DATE, 
    JOB_ACTION, 
    JOB_CREATOR, 
    REPEAT_INTERVAL, 
    AUTO_DROP 
    FROM 
        ALL_SCHEDULER_JOBS
    WHERE 
        STATE LIKE '%RUNNING%'; 

--Lista JOBS AGENDADOS pela package DBMS_JOB
SELECT     
    LOG_USER,
    PRIV_USER,
    SCHEMA_USER,
    LAST_DATE,
    NEXT_DATE,
    NEXT_SEC,
    TOTAL_TIME,
    FAILURES,
    WHAT    
    FROM ALL_JOBS
        ORDER BY NEXT_DATE, NEXT_SEC;
        
--Lista JOBS AGENDADOS pela package DBMS_SCHEDULER        
SELECT * FROM all_scheduler_jobs WHERE JOB_NAME = 'seu job aqui'
        
--Consulta LOG de um job
select * from user_scheduler_job_log where job_name = 'seu job aqui';

--Verificação DETALHES DA EXECUÇÃO de um JOB
select * from USER_SCHEDULER_JOB_RUN_DETAILS;

--Verifica JOBS EXECUTADOS COM SUCESSO
select count(*)
from(
select 
    job_name,
    last_run_duration,
    start_date,
    state
    from all_scheduler_jobs 
    where state = 'SUCCEEDED'
    order by start_date
    )
        
--Altera DESCRIÇÃO de um job
exec DBMS_JOB.WHAT(23708,'BEGIN loop delete from ORDER_WEBSERVICE WHERE PEW_DH <= sysdate - 365 and rownum <= 5000;  exit when sql%rowcount= 0; COMMIT; end loop; COMMIT; END;');

--Altera INTERVALO de um job
execute DBMS_JOB.INTERVAL(23708, 'TRUNC(SYSDATE+1)');
            
-- ELIMINA um Job
BEGIN
  DBMS_SCHEDULER.drop_job (job_name => 'seu job aqui'
END;

--EXECUÇÃO MANUAL de um job
BEGIN
   dbms_scheduler.run_job('seu job aqui');
END;

--PARAR um job
BEGIN
   exec dbms_scheduler.stop_job('seu job aqui');
END;

--Verifica QTDE JOBS AGENDADOS
select count(*)
from(
select 
    job_name,
    state,
    last_start_date,
    last_run_duration
    from all_scheduler_jobs order by start_date
)
