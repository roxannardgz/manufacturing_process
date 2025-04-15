# Evaluation of a Manifacturing Process

### GOAL
To support process stability and quality assurance in a manufacturing setting by using SQL to implement **Statistical Process Control (SPC) techniques** — identifying deviations, flagging anomalies, and surfacing operational risks through data.
<br><br>

### OVERVIEW
This case study explores how SQL can be used to monitor a manufacturing process in real time. The goal was to go beyond simple aggregation and build logic that detects control limit violations, uncovers early signs of instability, and identifies systemic operator-related issues.
<br><br>

### CONTEXT
In manufacturing, even small deviations can have cascading effects. By applying control limits and SPC techniques, organizations can avoid unnecessary process adjustments while reacting quickly to real issues. This project simulates that monitoring process using a manufacturing_parts dataset and SQL queries that rely on window functions, conditional logic, and row-level flags.
<br><br>

### TASKS
Each question in the analysis built upon the last, moving from basic control flagging to operational insights:

* **Control Limit Alert**
  - 📌 Purpose: Flag any product whose height falls outside rolling control limits.
  - 🧠 Why it matters: SPC depends on real-time detection of anomalies, so these flags are the foundation for more advanced monitoring.
  - 💡 Business value: Enables immediate detection of faulty outputs and supports consistent quality across production runs.

* **Rolling Mean Deviation.**
  -📌 Purpose: Track how much a part's height deviates from the recent average.
  - 🧠 Why it matters: Subtle shifts in measurements can indicate an emerging issue.
  - 💡 Business value: Helps detect gradual drift before it leads to quality failures.

* **Control Limit Violations Count.**
  - 📌 Purpose: Count how many parts fall outside the control limits.
  - 🧠 Why it matters: Quantifies instability across the process.
  -💡 Business value: Enables targeted investigation into batches or shifts.

* **First Violation Detection.**
  - 📌 Purpose: Identify the first part in the production line that violates control limits.
  - 🧠 Why it matters: Early detection helps avoid widespread downstream issues.
  - 💡 Business value: Supports real-time alerting and faster corrective action.

* **Operator Stability Check.**
  - 📌 Purpose: Flags operators whose batches frequently contain violations.
  = 🧠 Why it matters: Repeated errors may reflect equipment calibration or training issues.
  = 💡 Business value: Informs retraining needs and resource allocation.
<br><br>

### Key Takeaways
Using SQL alone, this project demonstrates how manufacturing teams can implement core SPC practices using data they already collect. The resulting logic can be integrated into dashboards, alerting systems, or daily QC reports — no code migration or new tooling required.

