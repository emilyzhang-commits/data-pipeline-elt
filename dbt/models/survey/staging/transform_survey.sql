select
    timestamp,
    "EMAIL ADDRESS" as email_address,
    "WHAT IS YOUR AGE?" as age,
    "DO YOU OWN A VR HEADSET?" as own_vr_headset,
    "DO YOU PREFER CATS OR DOGS?" as prefer_cats_or_dogs,
    "WHAT IS YOUR CURRENT STANDING?" as current_standing,
    "WHAT IS YOUR FAVORITE TV SHOW?" as favorite_tv_show,
    "WHEN DO YOU PREFER TO TAKE EXAMS?" as preferred_exam_time,
    "  WHAT IS YOUR PREFERRED BEVERAGE?  " as preferred_beverage,
    "WHAT IS YOUR FAVORITE ICE CREAM FLAVOR?" as favorite_ice_cream_flavor,
    "  WHAT IS YOUR FAVORITE SEASON OF THE YEAR?  " as favorite_season,
    "WHAT IS YOUR FAVORITE OR PREFERRED LLM TO USE?" as preferred_llm,
    "WHAT FACTOR INFLUENCES YOUR COURSE SELECTION THE MOST?" as course_selection_factor,
    "WOULD YOU DESCRIBE YOURSELF AS AN ""EARLY BIRD"" OR A ""NIGHT OWL""?" as early_bird_or_night_owl,
    "IF YOU HAVE SECONDARY MAJORS, PLEASE LIST THEM HERE, SEPARATED BY A COMMA." as secondary_majors,
    "
WHICH BEST DESCRIBES YOUR PRIMARY MAJOR OR FIELD OF STUDY? IF YOU HAVE MORE THAN ONE MAJOR, PLEASE SPECIFY OTHER MAJORS AS PART OF THE NEXT QUESTION." as primary_major
from {{ source('airbyte_survey_data', 'survey') }}