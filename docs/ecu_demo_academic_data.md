# ECU Sri Lanka academic demo data

The repeatable, development-only population task is `demo_data:populate_ecu`. Run it with `RAILS_ENV=development bin/rails demo_data:populate_ecu`. It creates only missing units, fictional students, enrolments, and results. Existing matching records are retained; existing student rows are matched by their preserved name and course and updated in place to the standard ID/email format. Conflicting existing course or unit records abort the transaction. It does not create or update courses, users, passwords, marks, or unit ownership.

## Official catalogue sources

The catalogue names and structures in `lib/tasks/ecu_demo_data.rake` were transcribed from the following ECU Sri Lanka pages. Structures are indicative and subject to change as the pages themselves state.

| Existing course | ECU source |
| --- | --- |
| Bachelor of Computer Science (`ECU-BCS`) | https://www.ecu.edu.lk/study/undergraduate-degrees/computer-science/ |
| Bachelor of Science (Cyber Security) (`ECU-CYBER`) | https://www.ecu.edu.lk/study/undergraduate-degrees/science-cyber-security/ |
| Bachelor of Commerce (`ECU-BCOM`) | https://www.ecu.edu.lk/study/undergraduate-degrees/commerce/ |
| Bachelor of Communication (`ECU-BCOMM`) | https://www.ecu.edu.lk/study/undergraduate-degrees/communication/ |
| Bachelor of Design (`ECU-BDES`) | https://www.ecu.edu.lk/study/undergraduate-degrees/design/ |
| Bachelor of Psychology (`ECU-PSY`) | https://www.ecu.edu.lk/study/undergraduate-degrees/psychology/ |
| Bachelor of Biomedical Science (`ECU-BMS`) | https://www.ecu.edu.lk/study/undergraduate-degrees/science-biomedical/ |
| Bachelor of Technology (Engineering) major in Electrical (`ECU-BTECH`) | https://www.ecu.edu.lk/study/undergraduate-degrees/engineering/ |
| Bachelor of Science (Nursing Studies) (`ECU-NURS`) | https://www.ecu.edu.lk/study/undergraduate-degrees/science-nursing-studies/ |

No generic elective/major placeholder is stored as a real unit. The sample Cyber Security cross-discipline enrolments in CSI2441 (Computer Science), SBL1400 (Commerce), and CMM1610 (Communication) are illustrative demonstrations only; they do not imply ECU approval as degree electives.

## Ownership and credit limitations

The schema stores one `course_id` per unit, while the Computer Science and Cyber Security course structures both list some same-code units. The task omits these shared units rather than assigning them to one degree without evidence: SCI1125, CSP1150, MAT1252, CSI1241, CSG1105, CSI1101, ENS1161, CSG1207, CSP2348, CSP2104, CSG2341, CSG2344, CSI3344, CSP3341, and CSG3101. The official pages give CSG3101 as 30 credit points, but its owning-course ambiguity means it is not loaded. The biomedical source renders the code as `SCH 1101` with a space; that exact displayed code is retained pending confirmation of its canonical catalogue form.

The official pages retrieved for this task do not give point values for most listed units. The application requires a positive integer credit value and has used 15 in its existing model-test data; the task uses 15 solely as this app's explicit demo convention, **not** as a verified ECU unit credit. No WAM for these records should be represented as an official ECU academic calculation until authoritative point values are confirmed. The task preserves any existing valid credit value and does not overwrite an existing unit.

Marks and grades are fictional sample records. The task removes any old demo wrapper from grade strings, leaving the stored sample labels `A`, `B`, or `C`; these are not mapped from marks and do not assert ECU thresholds. The existing WAM method is not modified.

## Student records

The task defines 37 standard student records numbered `106000`–`106036`; the current development database may contain additional pre-existing student records. and all student email addresses to the `@our.ecu.edu.au` domain. Existing students' internal primary keys, names, courses, enrolments, results, and numeric marks are retained. It adds 18 further fictional students when absent and never modifies user accounts. Existing academic years below 2023 are normalized to 2023, 2027 to 2025, and 2028 or later to 2026; 2024–2026 remain unchanged. New illustrative enrolments use 2023–2024. Academic years and terms are examples only and are not an official study plan.
