SELECT 
    Jobs.id AS `Jobs__id`,
    Jobs.name AS `Jobs__name`,
    Jobs.media_id AS `Jobs__media_id`,
    Jobs.job_category_id AS `Jobs__job_category_id`,
    Jobs.job_type_id AS `Jobs__job_type_id`,
    Jobs.description AS `Jobs__description`,
    Jobs.detail AS `Jobs__detail`,
    Jobs.business_skill AS `Jobs__business_skill`,
    Jobs.salary_range_average AS `Jobs__salary_range_average`,
    JobCategories.name AS `JobCategories__name`,
    JobTypes.name AS `JobTypes__name`,
    MATCH (
        Jobs.name, 
        Jobs.description, 
        Jobs.detail, 
        Jobs.business_skill, 
        JobCategories.name, 
        JobTypes.name
    ) AGAINST ('キャビンアテンダント' IN NATURAL LANGUAGE MODE) AS relevance_score
FROM 
    jobs Jobs
INNER JOIN job_categories JobCategories
    ON JobCategories.id = Jobs.job_category_id
    AND JobCategories.deleted IS NULL
INNER JOIN job_types JobTypes
    ON JobTypes.id = Jobs.job_type_id
    AND JobTypes.deleted IS NULL
WHERE 
    MATCH (
        Jobs.name, 
        Jobs.description, 
        Jobs.detail, 
        Jobs.business_skill, 
        JobCategories.name, 
        JobTypes.name
    ) AGAINST ('キャビンアテンダント' IN NATURAL LANGUAGE MODE)
    AND Jobs.publish_status = 1
    AND Jobs.deleted IS NULL
ORDER BY 
    relevance_score DESC,
    Jobs.sort_order DESC,
    Jobs.id DESC
LIMIT 50;
