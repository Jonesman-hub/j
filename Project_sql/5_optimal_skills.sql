With skills_demand as (
    select 
        skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) as demand_count
    from job_postings_fact
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' and
        job_work_from_home = true and
        salary_year_avg is not null
    group BY
        skills_dim.skill_id
), average_salary as (
    select 
        skills_job_dim.skill_id,
        round (avg(salary_year_avg),2) as avg_salary
    from job_postings_fact
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        and salary_year_avg is not null
        and job_work_from_home = true
    group BY
        skills_job_dim.skill_id
)

select
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary

from 
    skills_demand
inner join average_salary on skills_demand.skill_id = average_salary.skill_id
Where
    demand_count > 10
order BY
    avg_salary DESC,
    demand_count desc
limit 25;

-- more concise rewrite

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) as demand_count,
    round(avg(job_postings_fact.salary_year_avg),2) as avg_salary
from job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where 
    job_title_short = 'Data Analyst'
    and salary_year_avg is not NULL
    and job_work_from_home = TRUE
group BY
    skills_dim.skill_id
HAVING
    count(skills_job_dim.job_id)>10
order by 
    avg_salary desc,
    demand_count DESC
limit 25;