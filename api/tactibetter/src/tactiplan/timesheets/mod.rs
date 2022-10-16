use serde::{Serialize, Deserialize};
use crate::tactiplan::{date_string_to_epoch, TactiError, time_string_to_epoch};

pub mod load;
pub mod save;

#[derive(Debug)]
pub struct TimesheetBlock {
    /// The date of the block.
    /// Set at 00:00 on the day
    pub date: i64,
    /// Unix epoch timestamp at which the block begins
    pub begin: i64,
    /// The Unix epoch timestamp at which the block ends
    pub end: i64,
    /// The department ID
    pub department: String,
    /// The task ID
    pub task: String,
    /// Whether the time block has been submitted for approval
    pub submitted: bool,
    /// Whether the submission is approved, can only be true if `submitted` is true.
    pub approved: bool,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
struct TactiScheduledBlock {
    pub date: String,
    pub begin: String,
    pub end: String,
    pub department_id: String,
    pub task_group_id: String,
}

impl TryFrom<TactiScheduledBlock> for TimesheetBlock {
    type Error = TactiError;
    fn try_from(x: TactiScheduledBlock) -> Result<Self, Self::Error> {
        Ok(TimesheetBlock {
            date: date_string_to_epoch(&x.date)?,
            begin: time_string_to_epoch(&x.begin)?,
            end: time_string_to_epoch(&x.end)?,
            department: x.department_id,
            task: x.task_group_id,
            submitted: false,
            approved: false,
        })
    }
}

#[derive(Debug, Clone, Deserialize, Serialize)]
struct TactiNote {
    pub text: String,
}