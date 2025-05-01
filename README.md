# Evaluation of a Manufacturing Process
*Manufacturing a process is much like assembling a puzzle — each step needs to fit precisely to ensure the final outcome meets quality standards.*

At a mid-sized manufacturing facility, the operations team was looking to improve how they monitored and controlled product quality on the shop floor. The existing process relied heavily on manual inspection and periodic checks, which made it difficult to catch deviations in real time or trace recurring quality issues back to their root cause.

To address this, the team explored adopting **Statistical Process Control (SPC)** — a data-driven method for monitoring whether a process stays within acceptable boundaries. Rather than reacting to every fluctuation, SPC focuses on detecting true process instability by flagging values that fall outside statistically defined control limits.

These control boundaries — the **Upper Control Limit (UCL)** and **Lower Control Limit (LCL)** — were calculated using historical production data and the following formulas:




<div style="text-align: center;">

 <p align="center">$UCL = height_{avg} + 3 * \frac{height_{stddev}}{\sqrt{5}}$</p> 
 <p align="center">$LCL = height_{avg} - 3 * \frac{height_{stddev}}{\sqrt{5}}$</p> 

</div>
<br>



These formulas incorporate the standard error of the mean (denominator = √5) to set more precise bounds based on small, rolling samples.

This project was built around the `manufacturing_parts` table, which contained production records with the following fields:
- `item_no`: the item number
- `length`: the length of the item made
- `width`: the width of the item made
- `height`: the height of the item made
- `operator`: the operating machine

Using SQL alone — specifically window functions, row numbering, common table expressions (CTEs), and lead/lag operations — we simulated how SPC techniques could be implemented to support real-time monitoring, reduce waste, and surface actionable process insights.
<br><br>

### 🎯 GOAL
To support process stability and quality assurance in a manufacturing setting by using SQL to apply **Statistical Process Control (SPC) techniques** — identifying deviations, flagging anomalies, and surfacing operational risks through data.
<br><br>

### 🗺️ OVERVIEW
This case study demonstrates how SQL can be used as a lightweight alternative to external SPC software. The objective was to move beyond basic metrics and build layered logic that tracks rolling averages, detects control limit violations, highlights recurring problem areas, and identify potential quality risks — all from within the database.
<br><br>

### 🏭 CONTEXT
In manufacturing, even small deviations can lead to costly downstream issues — whether it’s defective parts, increased rework, or delays. SPC provides a framework to distinguish between random variation and actual process shifts, helping teams avoid unnecessary corrections while still reacting quickly when needed.

In this simulation, we applied SPC logic using SQL directly on production data, replicating how such monitoring could work live on a factory floor.
<br><br>

### 🔍 TASKS
Each query built upon the last, progressively layering in more targeted insights:

* **Control Limit Alert**
  - 📌 Purpose: Flag any product whose height falls outside rolling control limits.
  - 🧠 Why it matters: SPC depends on real-time detection of anomalies, so these flags are the foundation for more advanced monitoring.
  - 💡 Business value: Enables real-time quality monitoring and early detection and rejection of faulty outputs.

* **Rolling Mean Deviation.**
  - 📌 Purpose: Compare each rolling 5-part average to the overall average per operator.
  - 🧠 Why it matters: Subtle shifts in measurements can indicate an emerging issue.
  - 💡 Business value: Helps detect gradual drift before it leads to quality failures.

* **Control Limit Violations Count.**
  - 📌 Purpose: Count how many violations occurred per operator.
  - 🧠 Why it matters: Quantifies instability across the process.
  - 💡 Business value: Enables targeted investigation into batches or shifts.

* **First Violation Detection.**
  - 📌 Purpose: Identify the first part in the production line that violates control limits.
  - 🧠 Why it matters: Early detection helps avoid widespread downstream issues.
  - 💡 Business value: Supports root-cause analysis and early intervention.

* **Operator Stability Check.**
  - 📌 Purpose: Flag operators who produce consecutive violations.
  - 🧠 Why it matters: Consecutive failures can signal deeper issues with calibration, training, or equipment.
  - 💡 Business value: Informs retraining needs and resource allocation.
<br><br>

### 🧩 Key Takeaways
This project shows that SPC practices can be implemented directly within a SQL environment, without requiring new tools or platforms. With just historical production data and core SQL features, teams can begin to monitor process health, flag anomalies, and uncover deeper operational trends — paving the way for more robust quality assurance at scale. This opens the door to faster quality feedback, better operator accountability, and scalable QC processes without introducing new software tools.



