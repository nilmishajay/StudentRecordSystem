namespace :demo_data do
  desc "Safely add ECU Sri Lanka academic demo data (development only)"
  task populate_ecu: :environment do
    raise "This task is restricted to the development environment" unless Rails.env.development?

    course_catalog = {
      "CS" => [ "ECU-BCS", "Bachelor of Computer Science" ],
      "CYBER" => [ "ECU-CYBER", "Bachelor of Science (Cyber Security)" ],
      "COM" => [ "ECU-BCOM", "Bachelor of Commerce" ],
      "COMM" => [ "ECU-BCOMM", "Bachelor of Communication" ],
      "DESIGN" => [ "ECU-BDES", "Bachelor of Design" ],
      "PSY" => [ "ECU-PSY", "Bachelor of Psychology" ],
      "BIO" => [ "ECU-BMS", "Bachelor of Biomedical Science" ],
      "ENG" => [ "ECU-BTECH", "Bachelor of Technology (Engineering) major in Electrical" ],
      "NURS" => [ "ECU-NURS", "Bachelor of Science (Nursing Studies)" ]
    }.freeze

    students = [
      [ "106001", "Kavindu", "Senanayake", "CS" ],
      [ "106002", "Amaya", "Perera", "CS" ],
      [ "106003", "Tharushi", "Wijesinghe", "CYBER" ],
      [ "106004", "Ruvin", "Fernando", "CYBER" ],
      [ "106005", "Shenali", "Abeywardena", "COM" ],
      [ "106006", "Isuru", "Bandara", "COM" ],
      [ "106007", "Minoli", "Jayasinghe", "COMM" ],
      [ "106008", "Keshan", "Rodrigo", "COMM" ],
      [ "106009", "Nethmi", "Gunasekara", "DESIGN" ],
      [ "106010", "Dilan", "Weerasinghe", "DESIGN" ],
      [ "106011", "Savindi", "Amarasinghe", "PSY" ],
      [ "106012", "Pasindu", "Herath", "PSY" ],
      [ "106013", "Oshadi", "Karunaratne", "BIO" ],
      [ "106014", "Malith", "Ekanayake", "BIO" ],
      [ "106015", "Dinara", "Senaviratne", "ENG" ],
      [ "106016", "Thevindu", "Maduranga", "ENG" ],
      [ "106017", "Hiruni", "Peiris", "NURS" ],
      [ "106018", "Akila", "Samarakoon", "NURS" ]
    ].freeze

    legacy_student_numbers = (1..18).to_h do |number|
      [ format("260610%02d", number), format("106%03d", number) ]
    end.freeze
    preserved_email_usernames = { "106000" => "DINITHJ" }.freeze

    students += [
      [ "106000", "Dinith", "Jayalath", "CYBER" ]
    ]
    students = [ students.last ] + students.first(18) + [
      [ "106019", "Aarav", "Abeysinghe", "CS" ],
      [ "106020", "Mihiri", "Dissanayake", "CS" ],
      [ "106021", "Nuwan", "Wickramasinghe", "CYBER" ],
      [ "106022", "Sithmi", "Rajapaksha", "CYBER" ],
      [ "106023", "Rehan", "Wijeratne", "COM" ],
      [ "106024", "Piumi", "Senanayake", "COM" ],
      [ "106025", "Anuki", "Fernando", "COMM" ],
      [ "106026", "Rashan", "Gunawardena", "COMM" ],
      [ "106027", "Thilini", "Peris", "DESIGN" ],
      [ "106028", "Sahan", "Abeykoon", "DESIGN" ],
      [ "106029", "Imesha", "Karunathilaka", "PSY" ],
      [ "106030", "Dewin", "Samarasinghe", "PSY" ],
      [ "106031", "Yasara", "Fernando", "BIO" ],
      [ "106032", "Chamod", "Liyanage", "BIO" ],
      [ "106033", "Kavisha", "Mendis", "ENG" ],
      [ "106034", "Bhanuka", "Peiris", "ENG" ],
      [ "106035", "Nadeesha", "Silva", "NURS" ],
      [ "106036", "Ravindu", "Amarasinghe", "NURS" ]
    ]

    # Structure lists below exclude generic elective placeholders. Units shown by
    # multiple degree structures (notably the CS/Cyber shared core) are omitted
    # because this schema has only one owning course per unit.
    unit_catalog = [
      # Computer Science: official structure years 2 and 3.
      [ "CS", "CSI2312", "Foundations of Software Engineering", 15 ],
      [ "CS", "CSI2343", "Object Oriented Analysis and Design", 15 ],
      [ "CS", "CSP2108", "Introduction to Mobile Applications Development", 15 ],
      [ "CS", "CSI2441", "Applications Development", 15 ],
      [ "CS", "CSI3105", "Software Testing", 15 ],
      [ "CS", "CSI3106", "Software Architectures and Design", 15 ],

      # Cyber Security: course-specific units; shared CS/Cyber core is omitted.
      [ "CYBER", "CSI2450", "IoT and OT Security", 15 ],
      [ "CYBER", "CSP2101", "Scripting Languages", 15 ],
      [ "CYBER", "CSI2107", "Malware Analysis", 15 ],
      [ "CYBER", "CSI3350", "Enterprise Security and Governance", 15 ],
      [ "CYBER", "CSI3351", "Cyber Security Incident Detection and Response", 15 ],
      [ "CYBER", "CSI3208", "Ethical Hacking and Defence", 15 ],

      # Commerce: common core plus named units from the three listed majors.
      [ "COM", "SBL1100", "Foundations of Business", 15 ],
      [ "COM", "SBL1200", "Accounting and Finance Essentials", 15 ],
      [ "COM", "SBL1300", "Business Environments & Markets", 15 ],
      [ "COM", "SBL1400", "Introduction to Business Analytics", 15 ],
      [ "COM", "SBL1500", "Ethics and Responsibility in Business", 15 ],
      [ "COM", "SBL1800", "Work and Career", 15 ],
      [ "COM", "SBL2800", "Professional Engagement and planning", 15 ],
      [ "COM", "SBL3800", "Professional Practice", 15 ],
      [ "COM", "MAN1100", "Management", 15 ],
      [ "COM", "MAN2120", "Organisational Behaviour", 15 ],
      [ "COM", "MAN2145", "Human Resource Management", 15 ],
      [ "COM", "SBL2100", "Cultural Business Intelligence", 15 ],
      [ "COM", "MAN2610", "Managing for Sustainability", 15 ],
      [ "COM", "MAN3315", "Negotiation", 15 ],
      [ "COM", "MAN3503", "Strategic Management", 15 ],
      [ "COM", "MAN3121", "Leadership", 15 ],
      [ "COM", "INB2102", "International Business", 15 ],
      [ "COM", "MAN3246", "International Human Resource Management", 15 ],
      [ "COM", "INB3303", "Global Trade", 15 ],
      [ "COM", "INB3202", "International Business Project", 15 ],
      [ "COM", "MKT1600", "Marketing Principles & Practices", 15 ],
      [ "COM", "MKT2810", "Digital Marketing", 15 ],
      [ "COM", "MKT2608", "Understanding Buyer Behaviour", 15 ],
      [ "COM", "MKT2700", "Applied Omnichannel Marketing", 15 ],
      [ "COM", "MKT2805", "Social Media Marketing", 15 ],
      [ "COM", "MKT3600", "Market Analysis and Creative Innovation", 15 ],
      [ "COM", "MKT3820", "Data Analysis for Marketing Insights", 15 ],
      [ "COM", "MKT3601", "Marketing Strategy", 15 ],

      # Communication: specifically named units across the published structure.
      [ "COMM", "CMM1600", "Foundations of Advertising", 15 ],
      [ "COMM", "CMM1605", "Communication Campaigns", 15 ],
      [ "COMM", "JBM1600", "Radio and Podcast Production", 15 ],
      [ "COMM", "CMM1610", "Understanding Audiences", 15 ],
      [ "COMM", "CMM1615", "Media Content Strategy", 15 ],
      [ "COMM", "JBM1615", "Media Law and Ethics", 15 ],
      [ "COMM", "CMM2600", "Digital Content Creation", 15 ],
      [ "COMM", "CMM2605", "Principles of Inclusive Communication", 15 ],
      [ "COMM", "JBM2600", "Storytelling and Social Media Influence", 15 ],
      [ "COMM", "JBM1605", "Fundamentals of Journalism", 15 ],
      [ "COMM", "CMM2610", "Strategic Branding", 15 ],
      [ "COMM", "CMM2615", "Strategic Social Media", 15 ],
      [ "COMM", "CMM3600", "Corporate Communication", 15 ],
      [ "COMM", "CMM3605", "Global Communication", 15 ],
      [ "COMM", "CMM3650", "Communication Agency", 15 ],

      # Design: named core units; elective slots are not represented as units.
      [ "DESIGN", "DES1600", "Design Foundations", 15 ],
      [ "DESIGN", "DES1610", "Digital Design", 15 ],
      [ "DESIGN", "DES1605", "Design Prototyping", 15 ],
      [ "DESIGN", "DES1615", "Design Knowledge", 15 ],
      [ "DESIGN", "DES1620", "Design Thinking", 15 ],
      [ "DESIGN", "DES2600", "Design Studies", 15 ],
      [ "DESIGN", "DES2650", "Experience Design Studio", 15 ],
      [ "DESIGN", "DES2114", "Strategic Visual Communication", 15 ],
      [ "DESIGN", "DES2660", "Service and System Design Studio", 15 ],
      [ "DESIGN", "DES3650", "Design Studio 1", 15 ],
      [ "DESIGN", "DES3660", "Design Studio 2", 15 ],
      [ "DESIGN", "DES3610", "Design Futures", 15 ],

      # Psychology: published core units.
      [ "PSY", "PSY1101", "Introduction to Psychology", 15 ],
      [ "PSY", "PSY1115", "Psychology of Motivation and Emotion", 15 ],
      [ "PSY", "PSY1210", "Biopsychology, Sensation and Perception", 15 ],
      [ "PSY", "PSY1204", "Social Determinants of Behaviour", 15 ],
      [ "PSY", "PSY2102", "Fundamentals of Psychological Inquiry", 15 ],
      [ "PSY", "PSY2105", "Psychology of Personality and Individual Differences", 15 ],
      [ "PSY", "PSY2204", "Learning, Memory and Cognition", 15 ],
      [ "PSY", "PSY2231", "Development Psychology", 15 ],
      [ "PSY", "PSY3105", "Advanced Methods of Psychological Inquiry", 15 ],
      [ "PSY", "PSY3456", "Mental Health and Psychological Interventions", 15 ],
      [ "PSY", "PSY3217", "Cultural Issues in Psychology", 15 ],
      [ "PSY", "PSY3225", "Applications of Psychological Literacy", 15 ],

      # Biomedical Science: exact code rendering retained from the source, including SCH's displayed space.
      [ "BIO", "SCH 1101", "Society Health and Culture", 15 ],
      [ "BIO", "MHS1101", "Anatomy and Physiology 1", 15 ],
      [ "BIO", "MAT1114", "Introduction to Statistics", 15 ],
      [ "BIO", "SCC1123", "Chemistry for the Life Sciences (for students without a Chemistry background)", 15 ],
      [ "BIO", "SCH1133", "Human Genetics", 15 ],
      [ "BIO", "SCC1226", "Introduction to Organic Chemistry and Biochemistry", 15 ],
      [ "BIO", "MHS1102", "Anatomy and Physiology 2", 15 ],
      [ "BIO", "SCH1104", "Introduction to Pathophysiology", 15 ],
      [ "BIO", "SCH1132", "Human Evolution and Ecology", 15 ],
      [ "BIO", "SCH2235", "Applied Microbiology", 15 ],
      [ "BIO", "SCH1111", "Fundamental Biomedical Techniques", 15 ],
      [ "BIO", "SCH3145", "Biomedical Ethics", 15 ],
      [ "BIO", "SCH3239", "Human Immunology", 15 ],
      [ "BIO", "SCH2111", "Applied Physiology", 15 ],
      [ "BIO", "SCH2232", "Medical Biochemistry", 15 ],
      [ "BIO", "SCH2105", "Principles of Pharmacology", 15 ],
      [ "BIO", "SCH2142", "Forensic Genetics", 15 ],
      [ "BIO", "SCH2226", "Human Molecular Genetics", 15 ],
      [ "BIO", "SCH2141", "Advanced Biomedical Techniques", 15 ],
      [ "BIO", "SCH3227", "The Biology of Human Disease", 15 ],
      [ "BIO", "SCH3244", "Developmental biology", 15 ],
      [ "BIO", "MMS3101", "Evolutionary Perspectives on Health and Disease", 15 ],
      [ "BIO", "SCH3223", "Medical Genetics", 15 ],
      [ "BIO", "SCH3434", "Human Reproduction, Development and Ageing", 15 ],
      [ "BIO", "MMS3500", "Professional Practice in Biomedical Science", 15 ],

      # Electrical Engineering: named core and major units. Elective/major placeholders omitted.
      [ "ENG", "ENS1154", "Introduction to Engineering", 15 ],
      [ "ENG", "MAT1137", "Introductory Applied Mathematics", 15 ],
      [ "ENG", "ENS1115", "Materials and Manufacturing 1", 15 ],
      [ "ENG", "SCP1132", "Introduction to Physics", 15 ],
      [ "ENG", "ENS1101", "Engineering Mechanics", 15 ],
      [ "ENG", "MAT1250", "Mathematics 1", 15 ],
      [ "ENG", "ENS1253", "Electrical Engineering Fundamentals", 15 ],
      [ "ENG", "ENS1180", "Introduction to Energy and Resource Engineering", 15 ],
      [ "ENG", "ENS2120", "Engineering Systems", 15 ],
      [ "ENG", "ENM1102", "Engineering Drawing and Computer Aided Design", 15 ],
      [ "ENG", "CSP2151", "Programming Fundamentals", 15 ],
      [ "ENG", "ENS2159", "Engineering Innovation and Ethics", 15 ],
      [ "ENG", "ENS3173", "Technology Practicum", 15 ],
      [ "ENG", "ENS3201", "Technology Project", 15 ],
      [ "ENG", "ENS3216", "Engineering Management", 15 ],
      [ "ENG", "ENM2104", "Instrumentation and Measurement", 15 ],
      [ "ENG", "ENS2456", "Digital Electronics", 15 ],
      [ "ENG", "ENS2457", "Analog Electronics", 15 ],
      [ "ENG", "ENS3553", "Signals and Systems", 15 ],
      [ "ENG", "ENS3206", "Power Systems 1", 15 ],
      [ "ENG", "ENS3212", "Electrical Machines and Transformers", 15 ],
      [ "ENG", "ENS3551", "Electrical Networks", 15 ],
      [ "ENG", "ENS3215", "Power Electronics", 15 ],
      [ "ENG", "ENS5240", "Industrial Control", 15 ],

      # Nursing Studies: the eight specifically named core units (advanced-standing course).
      [ "NURS", "NSI1101", "Research Methods, Appraisals and Statistics", 15 ],
      [ "NURS", "NSI1205", "Healthcare Ethics and Law", 15 ],
      [ "NURS", "NSI2303", "Chronic Conditions and Supportive Nursing Care", 15 ],
      [ "NURS", "NSI2402", "Nursing Older People", 15 ],
      [ "NURS", "NSI2307", "Mental Health and Wellness Nursing", 15 ],
      [ "NURS", "NSI3111", "Health Assessment and Clinical Decision Making", 15 ],
      [ "NURS", "NSI3605", "Leadership, Governance and Organisational Culture for Nurses", 15 ],
      [ "NURS", "NSI3613", "Teaching and Learning", 15 ]
    ].freeze

    # [student_number, unit_code, semester, academic_year, mark, grade]
    # Grade text is explicitly illustrative and has no automatic threshold mapping.
    enrolment_scenarios = [
      [ "26061001", "CSI2312", "Semester 1", 2027, 78, "B" ],
      [ "26061001", "CSI2441", "Semester 2", 2027, 86, "A" ],
      [ "26061001", "CSI3105", "Semester 1", 2028, nil, nil ],
      [ "26061002", "CSI2343", "Semester 1", 2027, 69, "C" ],
      [ "26061002", "CSP2108", "Semester 2", 2027, nil, nil ],
      [ "26061002", "CSI3106", "Semester 1", 2028, 91, "A" ],

      [ "26061003", "CSI2450", "Semester 1", 2027, 82, "B" ],
      [ "26061003", "CSP2101", "Semester 2", 2027, 74, "C" ],
      [ "26061003", "CSI3350", "Semester 1", 2028, nil, nil ],
      [ "26061003", "CSI2441", "Semester 1", 2026, 88, "A" ],
      [ "26061003", "SBL1400", "Semester 2", 2026, 71, "C" ],
      [ "26061003", "CMM1610", "Semester 1", 2026, nil, nil ],
      [ "26061004", "CSI2107", "Semester 1", 2027, 63, "C" ],
      [ "26061004", "CSI3351", "Semester 1", 2028, 95, "A" ],
      [ "26061004", "CSI3208", "Semester 2", 2028, nil, nil ],

      [ "26061005", "SBL1100", "Semester 1", 2026, 76, "B" ],
      [ "26061005", "SBL1400", "Semester 2", 2026, 88, "A" ],
      [ "26061005", "MAN2120", "Semester 1", 2027, nil, nil ],
      [ "26061005", "MKT3601", "Semester 1", 2028, 68, "C" ],
      [ "26061006", "SBL1200", "Semester 1", 2026, 57, "C" ],
      [ "26061006", "MKT1600", "Semester 2", 2026, 81, "B" ],
      [ "26061006", "INB2102", "Semester 1", 2027, nil, nil ],
      [ "26061006", "MKT3820", "Semester 1", 2028, 92, "A" ],

      [ "26061007", "CMM1600", "Semester 1", 2026, 84, "B" ],
      [ "26061007", "CMM1610", "Semester 2", 2026, nil, nil ],
      [ "26061007", "CMM2600", "Semester 1", 2027, 73, "C" ],
      [ "26061007", "CMM3650", "Semester 2", 2028, 90, "A" ],
      [ "26061008", "JBM1600", "Semester 1", 2026, 66, "C" ],
      [ "26061008", "CMM1615", "Semester 2", 2026, 79, "B" ],
      [ "26061008", "JBM1605", "Semester 1", 2027, nil, nil ],
      [ "26061008", "CMM3605", "Semester 2", 2028, 87, "A" ],

      [ "26061009", "DES1600", "Semester 1", 2026, 92, "A" ],
      [ "26061009", "DES1610", "Semester 2", 2026, 81, "B" ],
      [ "26061009", "DES2650", "Semester 1", 2027, nil, nil ],
      [ "26061009", "DES3650", "Semester 1", 2028, 77, "B" ],
      [ "26061010", "DES1605", "Semester 1", 2026, 70, "C" ],
      [ "26061010", "DES1620", "Semester 2", 2026, nil, nil ],
      [ "26061010", "DES2660", "Semester 2", 2027, 85, "B" ],
      [ "26061010", "DES3610", "Semester 1", 2028, 94, "A" ],

      [ "26061011", "PSY1101", "Semester 1", 2026, 83, "B" ],
      [ "26061011", "PSY1204", "Semester 2", 2026, 72, "C" ],
      [ "26061011", "PSY2102", "Semester 1", 2027, nil, nil ],
      [ "26061011", "PSY3456", "Semester 1", 2028, 89, "A" ],
      [ "26061012", "PSY1115", "Semester 1", 2026, 61, "C" ],
      [ "26061012", "PSY1210", "Semester 2", 2026, nil, nil ],
      [ "26061012", "PSY2105", "Semester 1", 2027, 80, "B" ],
      [ "26061012", "PSY3217", "Semester 1", 2028, 96, "A" ],

      [ "26061013", "SCH 1101", "Semester 1", 2026, 75, "B" ],
      [ "26061013", "MHS1101", "Semester 1", 2026, 68, "C" ],
      [ "26061013", "SCH2235", "Semester 1", 2027, nil, nil ],
      [ "26061013", "SCH2226", "Semester 1", 2028, 87, "A" ],
      [ "26061014", "SCC1123", "Semester 1", 2026, 59, "C" ],
      [ "26061014", "MHS1102", "Semester 2", 2026, 82, "B" ],
      [ "26061014", "SCH3239", "Semester 1", 2027, 73, "C" ],
      [ "26061014", "SCH3244", "Semester 1", 2028, nil, nil ],

      [ "26061015", "ENS1154", "Semester 1", 2026, 79, "B" ],
      [ "26061015", "ENS1253", "Semester 2", 2026, 90, "A" ],
      [ "26061015", "ENS2120", "Semester 1", 2027, nil, nil ],
      [ "26061015", "ENS3201", "Semester 1", 2028, 85, "B" ],
      [ "26061016", "ENS1115", "Semester 1", 2026, 63, "C" ],
      [ "26061016", "SCP1132", "Semester 2", 2026, 76, "B" ],
      [ "26061016", "ENM2104", "Semester 1", 2027, 88, "A" ],
      [ "26061016", "ENS3215", "Semester 1", 2028, nil, nil ],

      [ "26061017", "NSI1101", "Semester 1", 2026, 86, "A" ],
      [ "26061017", "NSI1205", "Semester 1", 2026, nil, nil ],
      [ "26061017", "NSI2303", "Semester 2", 2026, 74, "C" ],
      [ "26061017", "NSI3111", "Semester 2", 2026, 92, "A" ],
      [ "26061018", "NSI2402", "Semester 1", 2026, 67, "C" ],
      [ "26061018", "NSI2307", "Semester 1", 2026, nil, nil ],
      [ "26061018", "NSI3605", "Semester 2", 2026, 81, "B" ],
      [ "26061018", "NSI3613", "Semester 2", 2026, 95, "A" ]
    ].map do |student_number, unit_code, semester, year, mark, grade|
      normalized_year = case year
      when ...2023 then 2023
      when 2027 then 2025
      when 2028.. then 2026
      else year
      end
      normalized_grade = grade&.sub(/\ADemo\s+/i, "")&.sub(/\s+Demo\z/i, "")
      [ legacy_student_numbers.fetch(student_number, student_number), unit_code, semester, normalized_year, mark, normalized_grade ]
    end

    enrolment_scenarios += [
      [ "106019", "CSI2312", "Semester 1", 2023, 78, "B" ], [ "106019", "CSI2441", "Semester 2", 2024, 86, "A" ],
      [ "106020", "CSI2343", "Semester 1", 2023, 69, "C" ], [ "106020", "CSI3105", "Semester 1", 2024, nil, nil ],
      [ "106021", "CSI2450", "Semester 1", 2023, 82, "B" ], [ "106021", "CSI3350", "Semester 1", 2024, 74, "C" ],
      [ "106022", "CSI2107", "Semester 1", 2023, 63, "C" ], [ "106022", "CSI3208", "Semester 1", 2024, 95, "A" ],
      [ "106023", "SBL1100", "Semester 1", 2023, 76, "B" ], [ "106023", "SBL1400", "Semester 1", 2024, 88, "A" ],
      [ "106024", "SBL1200", "Semester 1", 2023, 57, "C" ], [ "106024", "MKT1600", "Semester 2", 2024, nil, nil ],
      [ "106025", "CMM1600", "Semester 1", 2023, 84, "B" ], [ "106025", "CMM2600", "Semester 1", 2024, 73, "C" ],
      [ "106026", "JBM1600", "Semester 1", 2023, 66, "C" ], [ "106026", "CMM3605", "Semester 2", 2024, 87, "A" ],
      [ "106027", "DES1600", "Semester 1", 2023, 92, "A" ], [ "106027", "DES2650", "Semester 1", 2024, nil, nil ],
      [ "106028", "DES1605", "Semester 1", 2023, 70, "C" ], [ "106028", "DES3610", "Semester 1", 2024, 94, "A" ],
      [ "106029", "PSY1101", "Semester 1", 2023, 83, "B" ], [ "106029", "PSY2102", "Semester 1", 2024, 72, "C" ],
      [ "106030", "PSY1115", "Semester 1", 2023, 61, "C" ], [ "106030", "PSY3456", "Semester 1", 2024, nil, nil ],
      [ "106031", "SCH 1101", "Semester 1", 2023, 75, "B" ], [ "106031", "SCH2235", "Semester 1", 2024, 68, "C" ],
      [ "106032", "SCC1123", "Semester 1", 2023, 59, "C" ], [ "106032", "SCH2226", "Semester 1", 2024, 82, "B" ],
      [ "106033", "ENS1154", "Semester 1", 2023, 79, "B" ], [ "106033", "ENS2120", "Semester 1", 2024, 90, "A" ],
      [ "106034", "ENS1115", "Semester 1", 2023, 63, "C" ], [ "106034", "ENS3215", "Semester 1", 2024, nil, nil ],
      [ "106035", "NSI1101", "Semester 1", 2023, 86, "A" ], [ "106035", "NSI2303", "Semester 2", 2024, 74, "C" ],
      [ "106036", "NSI2402", "Semester 1", 2023, 67, "C" ], [ "106036", "NSI3613", "Semester 2", 2024, 95, "A" ]
    ]

    enrolment_scenarios.freeze

    # The ECU catalogue pages identify most structures but do not publish
    # per-unit credit points in their text. Fifteen is the existing app test
    # convention, used only as a clearly documented demo value. CSG3101 is
    # explicitly 30 points on both CS/Cyber pages but omitted below because the
    # existing one-course-per-unit schema cannot represent its shared ownership.
    default_demo_credit = 15

    created = Hash.new(0)
    preserved = Hash.new(0)
    skipped_students = []
    wam_values = {}

    ActiveRecord::Base.transaction do
      duplicate_course_codes = Course.group(:code).having("COUNT(*) > 1").count
      duplicate_student_numbers = Student.group(:student_number).having("COUNT(*) > 1").count
      duplicate_unit_codes = Unit.group(:code).having("COUNT(*) > 1").count
      duplicate_enrolments = Enrolment.group(:student_id, :unit_id, :semester, :academic_year).having("COUNT(*) > 1").count
      duplicate_results = Result.group(:enrolment_id).having("COUNT(*) > 1").count
      raise "Duplicate course codes already exist: #{duplicate_course_codes.keys.inspect}" if duplicate_course_codes.any?
      raise "Duplicate student numbers already exist: #{duplicate_student_numbers.keys.inspect}" if duplicate_student_numbers.any?
      raise "Duplicate unit codes already exist: #{duplicate_unit_codes.keys.inspect}" if duplicate_unit_codes.any?
      raise "Duplicate enrolment keys already exist: #{duplicate_enrolments.keys.inspect}" if duplicate_enrolments.any?
      raise "Duplicate results per enrolment already exist: #{duplicate_results.keys.inspect}" if duplicate_results.any?

      normalize_year = lambda do |year|
        case year
        when ...2023 then 2023
        when 2027 then 2025
        when 2028.. then 2026
        else year
        end
      end
      planned_enrolments = Enrolment.pluck(:student_id, :unit_id, :semester, :academic_year).map do |student_id, unit_id, semester, academic_year|
        [ student_id, unit_id, semester, normalize_year.call(academic_year) ]
      end
      if planned_enrolments.uniq.length != planned_enrolments.length
        raise "Academic-year normalization would create duplicate enrolments; no records were changed"
      end

      Enrolment.find_each do |enrolment|
        normalized_year = normalize_year.call(enrolment.academic_year)
        enrolment.update_columns(academic_year: normalized_year, updated_at: Time.current) if normalized_year != enrolment.academic_year
      end

      Result.where("grade ILIKE ?", "%Demo%").find_each do |result|
        clean_grade = result.grade.to_s.gsub(/\ADemo\s+|\s+Demo\z/i, "").strip
        result.update!(grade: clean_grade)
      end

      courses = course_catalog.to_h do |key, (code, expected_name)|
        course = Course.find_by(code: code)
        raise "Required existing course #{code} (#{expected_name}) is missing" unless course
        unless course.name == expected_name
          raise "Course #{code} name mismatch: expected #{expected_name.inspect}, found #{course.name.inspect}; preserving existing record"
        end

        [ key, course ]
      end

      duplicate_catalog_codes = unit_catalog.group_by { |_course_key, code, _name, _credit| code }.select { |_code, rows| rows.size > 1 }
      raise "Duplicate codes in the demo catalogue: #{duplicate_catalog_codes.keys.inspect}" if duplicate_catalog_codes.any?

      units = {}
      unit_catalog.each do |course_key, code, name, listed_credit|
        course = courses.fetch(course_key)
        unit = Unit.find_by(code: code)
        if unit
          unless unit.name == name && unit.course_id == course.id
            raise "Existing unit #{code} conflicts with requested title/owner; preserving existing record and aborting"
          end
          preserved[:units] += 1
        else
          unit = Unit.create!(code: code, name: name, credit: listed_credit || default_demo_credit, course: course)
          created[:units] += 1
        end
        units[code] = unit
      end

      students_by_number = {}
      students.each do |student_number, first_name, last_name, course_key|
        course = courses.fetch(course_key)
        student = Student.find_by(student_number: student_number) ||
                  Student.find_by(first_name: first_name, last_name: last_name, course_id: course.id)
        if student
          if student.first_name == first_name && student.last_name == last_name && student.course_id == course.id
            conflicting_id = Student.where(student_number: student_number).where.not(id: student.id).exists?
            raise "Student number #{student_number} already belongs to another student" if conflicting_id

            local_part = preserved_email_usernames[student_number] || student.email.to_s.split("@", 2).first.presence || "#{first_name}.#{last_name}".parameterize
            local_part = local_part.gsub(/[^a-zA-Z0-9._+-]/, "")
            email = "#{local_part}@our.ecu.edu.au"
            if Student.where("LOWER(email) = LOWER(?)", email).where.not(id: student.id).exists?
              email = "#{local_part}-#{student_number}@our.ecu.edu.au"
            end
            student.update!(student_number: student_number, email: email) if student.student_number != student_number || student.email != email
            preserved[:students] += 1
            students_by_number[student_number] = student
          else
            skipped_students << student_number
          end
          next
        end

        student = Student.create!(
          student_number: student_number,
          first_name: first_name,
          last_name: last_name,
          email: "#{first_name}.#{last_name}.#{student_number}@our.ecu.edu.au".downcase,
          course: course
        )
        created[:students] += 1
        students_by_number[student_number] = student
      end

      # Normalize any other pre-existing student records too; never touch user accounts.
      Student.where.not(id: students_by_number.values.map(&:id)).find_each do |student|
        local_part = student.email.to_s.split("@", 2).first.presence || "student-#{student.student_number}"
        local_part = local_part.gsub(/[^a-zA-Z0-9._+-]/, "")
        email = "#{local_part}@our.ecu.edu.au"
        if Student.where("LOWER(email) = LOWER(?)", email).where.not(id: student.id).exists?
          email = "#{local_part}-#{student.student_number}@our.ecu.edu.au"
        end
        student.update!(email: email) if student.email != email
      end

      enrolments_by_key = {}
      enrolment_scenarios.each do |student_number, unit_code, semester, academic_year, mark, grade|
        student = students_by_number[student_number]
        next unless student

        unit = units.fetch(unit_code) { raise "Scenario references unknown unit #{unit_code}" }
        enrolment = Enrolment.find_by(
          student_id: student.id,
          unit_id: unit.id,
          semester: semester,
          academic_year: academic_year
        )
        if enrolment
          preserved[:enrolments] += 1
        else
          enrolment = Enrolment.create!(student: student, unit: unit, semester: semester, academic_year: academic_year)
          created[:enrolments] += 1
        end
        enrolments_by_key[[ student_number, unit_code, semester, academic_year ]] = enrolment

        next if mark.nil?

        result = Result.find_by(enrolment_id: enrolment.id)
        if result
          preserved[:results] += 1
        else
          Result.create!(enrolment: enrolment, mark: mark, grade: grade)
          created[:results] += 1
        end
      end

      students_by_number.each do |student_number, student|
        wam_values[student_number] = student.wam
      end
    end

    puts "ECU academic demo data population complete (#{Rails.env})."
    puts "Created: #{created.inspect}"
    puts "Preserved matching records: #{preserved.inspect}"
    puts "Student numbers skipped because an existing record differed: #{skipped_students.inspect}"
    puts "Units by course:"
    Course.includes(:units).order(:code).each do |course|
      puts "  #{course.code} — #{course.units.size} units"
    end
    puts "WAM (only students with graded enrolments have values; grades are illustrative labels):"
    wam_values.each { |student_number, wam| puts "  #{student_number}: #{wam ? format('%.2f', wam) : 'Not available'}" }
    puts "Catalogue references: see docs/ecu_demo_academic_data.md"
  end
end
