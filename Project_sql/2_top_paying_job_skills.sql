With top_paying_jobs as (

SELECT
    job_id,
    job_title,
    salary_year_avg,

    name as company_name
From 
    job_postings_fact
Left Join company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' and 
    salary_year_avg is not null
Order BY
    salary_year_avg desc
LIMIT
    10
)

Select 
    top_paying_jobs.*,
    skills
from top_paying_jobs
inner join skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
order by 
    salary_year_avg desc