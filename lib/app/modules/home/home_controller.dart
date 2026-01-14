import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:willko_user/app/modules/home/service_details/service_details_view.dart';


class HomeController extends GetxController {
  // --- City selector (Hero card) ---
  final cities = <String>["Dhaka", "Chattogram", "Sylhet", "Khulna"].obs;
  final selectedCity = "Select your city".obs;

  // --- Why section items ---
  final whyItems = <Map<String, dynamic>>[
    {
      "icon": Icons.receipt_long_outlined,
      "title": "Transparent pricing",
      "subtitle": "See fixed prices before you book. No hidden charges.",
    },
    {
      "icon": Icons.workspace_premium_outlined,
      "title": "Experts only",
      "subtitle": "Our professionals are well trained and have on-job expertise.",
    },
    {
      "icon": Icons.work_outline_rounded,
      "title": "Fully equipped",
      "subtitle": "We bring everything needed to get the job done well.",
    },
  ].obs;

  void pickCity(String city) => selectedCity.value = city;

  // --- Services Offered (chips) ---
  final selectedServiceIndex = 0.obs;

  final services = <Map<String, dynamic>>[
    // ===================== SERVICE 1 =====================
    {
      "id": 101,
      "label": "AC Cleaning And Repair",
      "slug": "ac-cleaning-and-repair",
      "icon": Icons.ac_unit_rounded,
      "rating": 4.73,
      "bookings": "28K bookings",
      "items": [
        {"title": "Foam Deep\nCleaning", "image": "assets/images/s1.png"},
        {"title": "Repair", "image": "assets/images/s2.png"},
        {"title": "Install &\nUninstall", "image": "assets/images/s3.png"},
      ],
      "topBannerSlides": [
        {
          "title": "We've got you covered!",
          "bullets": [
            "30-day service guarantee",
            "Certified technicians with 7+ years of experience",
            "Fast, clean, and hassle-free service",
          ],
          "image": "assets/images/service_ac_hero.jpg",
        },
        {
          "title": "Certified specialists",
          "bullets": [
            "Background-verified professionals",
            "Tools included",
            "Transparent pricing",
          ],
          "image": "assets/images/service_ac_hero2.jpg",
        },
      ],
      "packagesByItem": {
        0: [
          {
            "tag": "2X FASTER COOLING",
            "title": "AC Deep Cleaning (Split)",
            "rating": 4.76,
            "reviews": "9K reviews",
            "priceStr": "Starts at SAR 99",
            "priceInt": 99,
            "optionsText": "10 options",
            "cardTitle": "Deep Cleaning for\nQuick Cooling",
            "cardBullets": [
              "Foam-jet deep cleaning",
              "Technicians with 7+ years experience",
              "30 days guarantee on service quality",
            ],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": [
              "Mess free deep cleaning with foam technology",
              "30 days free revisit in case of any issue",
            ],
            "description":
            "Complete foam-jet cleaning of indoor unit filters, coils, blades, and outer panel. Ensures faster cooling & cleaner air.",
            "howItWorks": [
              {"title": "Pre-service checks", "desc": "Inspection & gas check."},
              {"title": "Area preparation", "desc": "Cover floor & furniture."},
              {"title": "Foam cleaning", "desc": "Foam applied to coils."},
              {"title": "Jet rinse", "desc": "Rinse dirt thoroughly."},
            ],
            "ratingBreakdown": {
              "average": "4.76",
              "total": "9,124 ratings",
              "counts": [7000, 1500, 400, 124, 100],
            },
          },
          {
            "tag": "",
            "title": "AC Deep Cleaning (Window)",
            "rating": 4.77,
            "reviews": "786 reviews",
            "priceStr": "Starts at SAR 89",
            "priceInt": 89,
            "optionsText": "10 options",
            "cardTitle": "Deep cleaning with\nFoam Technology",
            "cardBullets": [
              "Foam deep cleaning",
              "Technicians with 7+ years experience",
              "30 days guarantee",
            ],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Foam cleaning for window AC", "Better cooling performance"],
            "description":
            "Window AC deep cleaning using foam technology to remove deep dust.",
          },
        ],
        1: [
          {
            "tag": "SAME DAY REPAIR",
            "title": "AC Repair (Split/Window)",
            "rating": 4.69,
            "reviews": "3K reviews",
            "priceStr": "Starts at SAR 89",
            "priceInt": 89,
            "optionsText": "4 options",
            "cardTitle": "Stay cool with\nAC Repairing Service",
            "cardBullets": [
              "Same day service",
              "Technicians with 7+ years experience",
              "30 days guarantee on service quality",
            ],
            "image": "assets/images/service_ac_hero3.jpg",
            "shortDetails": [
              "Quotation post inspection",
              "30 days free revisit in case of any issue",
            ],
            "description":
            "Diagnosis & repair by trained technicians. Quote shared before repair.",
          },
        ],
        2: [
          {
            "tag": "INSTALLATION",
            "title": "Relocation",
            "rating": 4.58,
            "reviews": "25 reviews",
            "priceStr": "Starts at SAR 299",
            "priceInt": 299,
            "optionsText": "2 options",
            "cardTitle": "Flawless Installation\nProficiency",
            "cardBullets": [
              "Technicians with 7+ years experience",
              "30 days guarantee on service quality",
            ],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": [
              "Removal & installation labor included",
              "Min. service charge if service not availed",
            ],
            "description":
            "Safe uninstallation and re-installation of your AC unit at a new location.",
          },
        ],
      },
    },

    // ===================== SERVICE 2 =====================
    {
      "id": 102,
      "label": "Plumbing",
      "slug": "plumbing",
      "icon": Icons.plumbing_rounded,
      "rating": 4.66,
      "bookings": "18K bookings",
      "items": [
        {"title": "Leak Fix", "image": "assets/images/s1.png"},
        {"title": "Tap Repair", "image": "assets/images/s2.png"},
        {"title": "Drain Clean", "image": "assets/images/s3.png"},
      ],
      "topBannerSlides": [
        {
          "title": "Fast plumbing help",
          "bullets": ["Quick booking", "Verified plumbers", "Transparent pricing"],
          "image": "assets/images/service_ac_hero2.jpg",
        },
        {
          "title": "No mess, no stress",
          "bullets": ["Tools included", "Professional finish", "Service warranty"],
          "image": "assets/images/service_ac_hero.jpg",
        },
      ],
      "packagesByItem": {
        // item 0
        0: [
          {
            "tag": "MOST BOOKED",
            "title": "Leakage Fix (Basic)",
            "rating": 4.71,
            "reviews": "2K reviews",
            "priceStr": "Starts at SAR 59",
            "priceInt": 59,
            "optionsText": "3 options",
            "cardTitle": "Leak fix\nin minutes",
            "cardBullets": ["Quick inspection", "Tools included", "Warranty"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Inspection + basic fix included", "Warranty on service"],
            "description":
            "Basic leakage diagnosis and fix for common issues (loose joints, minor pipe seepage). Spare parts extra if needed.",
            "howItWorks": [
              {"title": "Inspection", "desc": "Identify leak source and check joints/pipe condition."},
              {"title": "Fix", "desc": "Tighten joints, apply sealing and minor adjustments."},
              {"title": "Testing", "desc": "Run water flow test to confirm no leakage."},
            ],
            "ratingBreakdown": {
              "average": "4.71",
              "total": "2,045 ratings",
              "counts": [1500, 360, 110, 45, 30],
            },
          },
          {
            "tag": "BEST VALUE",
            "title": "Leakage Fix (Advanced)",
            "rating": 4.67,
            "reviews": "1.1K reviews",
            "priceStr": "Starts at SAR 89",
            "priceInt": 89,
            "optionsText": "4 options",
            "cardTitle": "Advanced leak\nsolution",
            "cardBullets": ["Better sealing", "Cleaner finish", "Thorough testing"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Advanced sealing & alignment", "Pressure + flow test included"],
            "description":
            "Advanced leak fixing for deeper seepage points. Includes stronger sealing and thorough pressure/flow testing.",
            "howItWorks": [
              {"title": "Leak tracing", "desc": "Check hidden seepage points and pressure loss signs."},
              {"title": "Advanced fix", "desc": "Sealing, alignment and secure joints to prevent repeat leak."},
              {"title": "Final test", "desc": "Pressure/flow test and area cleanup."},
            ],
            "ratingBreakdown": {
              "average": "4.67",
              "total": "1,128 ratings",
              "counts": [780, 240, 70, 20, 18],
            },
          },
          {
            "tag": "URGENT",
            "title": "Emergency Leak Fix (Visit + Diagnosis)",
            "rating": 4.60,
            "reviews": "640 reviews",
            "priceStr": "Starts at SAR 49",
            "priceInt": 49,
            "optionsText": "Add",
            "cardTitle": "Stop water\nwastage fast",
            "cardBullets": ["Quick visit", "Leak diagnosis", "Immediate safety steps"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Urgent visit + diagnosis", "Quote shared before repair"],
            "description":
            "Emergency visit for leakage diagnosis. Immediate temporary measures applied if needed. Repair quote shared before work.",
            "howItWorks": [
              {"title": "Quick assessment", "desc": "Identify leak severity and shutoff options."},
              {"title": "Diagnosis", "desc": "Find exact leak source and required repair scope."},
              {"title": "Quote", "desc": "Share transparent quote before proceeding."},
            ],
            "ratingBreakdown": {
              "average": "4.60",
              "total": "652 ratings",
              "counts": [420, 150, 45, 20, 17],
            },
          },
        ],

        // item 1
        1: [
          {
            "tag": "REPAIR",
            "title": "Tap Repair (Single)",
            "rating": 4.65,
            "reviews": "1.8K reviews",
            "priceStr": "Starts at SAR 29",
            "priceInt": 29,
            "optionsText": "Add",
            "cardTitle": "Fix dripping\ntaps",
            "cardBullets": ["Washer fix", "Leak prevention", "Testing included"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Fix drip/loose tap handle", "Flow test included"],
            "description":
            "Repair common tap issues like dripping, loose handle, minor leakage. Includes basic parts adjustment (parts extra if needed).",
            "howItWorks": [
              {"title": "Inspection", "desc": "Check washer, spindle, aerator and handle tightness."},
              {"title": "Repair", "desc": "Replace washer/adjust fitting and tighten connections."},
              {"title": "Testing", "desc": "Check flow, leakage and smooth operation."},
            ],
            "ratingBreakdown": {
              "average": "4.65",
              "total": "1,845 ratings",
              "counts": [1250, 410, 115, 45, 25],
            },
          },
          {
            "tag": "REPLACEMENT",
            "title": "Tap Replacement",
            "rating": 4.63,
            "reviews": "980 reviews",
            "priceStr": "Starts at SAR 49",
            "priceInt": 49,
            "optionsText": "2 options",
            "cardTitle": "New tap\ninstallation",
            "cardBullets": ["Neat fitting", "No leakage", "Cleanup included"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Remove old tap + install new", "Leak test + cleanup"],
            "description":
            "Replace old tap with a new one (tap provided by customer). Includes removal, fitting, sealing, and leak testing.",
            "howItWorks": [
              {"title": "Removal", "desc": "Remove old tap carefully without damaging fittings."},
              {"title": "Install", "desc": "Install new tap with sealing and alignment."},
              {"title": "Leak test", "desc": "Test flow, check joints, clean the area."},
            ],
            "ratingBreakdown": {
              "average": "4.63",
              "total": "992 ratings",
              "counts": [650, 240, 70, 20, 12],
            },
          },
          {
            "tag": "MIXER",
            "title": "Mixer Tap Repair",
            "rating": 4.61,
            "reviews": "720 reviews",
            "priceStr": "Starts at SAR 59",
            "priceInt": 59,
            "optionsText": "Add",
            "cardTitle": "Smooth mixer\ncontrol",
            "cardBullets": ["Handle stiffness fix", "Leak prevention", "Hot/cold balancing"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Fix mixer stiffness/leak", "Hot/cold water balance test"],
            "description":
            "Repair mixer tap issues like stiffness, leakage, uneven hot/cold flow. Includes calibration and final testing.",
            "howItWorks": [
              {"title": "Check cartridge", "desc": "Inspect cartridge and seals for wear."},
              {"title": "Repair", "desc": "Adjust/replace seals and calibrate flow."},
              {"title": "Testing", "desc": "Test hot/cold balance and leakage."},
            ],
            "ratingBreakdown": {
              "average": "4.61",
              "total": "735 ratings",
              "counts": [480, 180, 45, 18, 12],
            },
          },
        ],

        // item 2
        2: [
          {
            "tag": "CLOG REMOVAL",
            "title": "Drain Cleaning (Basic)",
            "rating": 4.64,
            "reviews": "1.6K reviews",
            "priceStr": "Starts at SAR 39",
            "priceInt": 39,
            "optionsText": "Add",
            "cardTitle": "Clear drains\nfast",
            "cardBullets": ["Blockage removal", "Odour reduction", "Flow test"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Basic clog removal", "Flow test included"],
            "description":
            "Basic drain cleaning for common clogs. Includes blockage removal and flow testing for smooth drainage.",
            "howItWorks": [
              {"title": "Assessment", "desc": "Check clog location and drain condition."},
              {"title": "Cleaning", "desc": "Remove blockage using tools and safe techniques."},
              {"title": "Flow test", "desc": "Run water and confirm free flow."},
            ],
            "ratingBreakdown": {
              "average": "4.64",
              "total": "1,602 ratings",
              "counts": [1080, 360, 105, 35, 22],
            },
          },
          {
            "tag": "DEEP CLEAN",
            "title": "Drain Deep Cleaning (Kitchen/Bath)",
            "rating": 4.67,
            "reviews": "980 reviews",
            "priceStr": "Starts at SAR 79",
            "priceInt": 79,
            "optionsText": "3 options",
            "cardTitle": "Deep drain\ncleaning",
            "cardBullets": ["Grease removal", "Deep flush", "Odour control"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Kitchen grease + sludge cleaning", "Deep flush + odour control"],
            "description":
            "Deep drain cleaning for stubborn kitchen/bath clogs and bad odour. Includes grease/sludge removal and deep flushing.",
            "howItWorks": [
              {"title": "Open & inspect", "desc": "Access drain, inspect sludge/grease buildup."},
              {"title": "Deep cleaning", "desc": "Clean buildup using tools and safe solutions."},
              {"title": "Flush test", "desc": "Deep flush and confirm strong flow."},
            ],
            "ratingBreakdown": {
              "average": "4.67",
              "total": "996 ratings",
              "counts": [720, 210, 45, 12, 9],
            },
          },
          {
            "tag": "DRAIN SLOW",
            "title": "Slow Drain Diagnosis",
            "rating": 4.58,
            "reviews": "520 reviews",
            "priceStr": "Starts at SAR 29",
            "priceInt": 29,
            "optionsText": "Add",
            "cardTitle": "Find the\nroot cause",
            "cardBullets": ["Diagnosis", "Recommendations", "Quote before repair"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Diagnose slow drain issue", "Quote shared before work"],
            "description":
            "Diagnosis service for slow drains. Technician identifies root cause and shares repair quote before proceeding.",
            "howItWorks": [
              {"title": "Diagnosis", "desc": "Check drain line, trap, slope and blockage points."},
              {"title": "Recommendation", "desc": "Suggest best fix method (basic/deep/line cleaning)."},
              {"title": "Quote", "desc": "Share transparent cost before any repair."},
            ],
            "ratingBreakdown": {
              "average": "4.58",
              "total": "532 ratings",
              "counts": [340, 135, 35, 12, 10],
            },
          },
        ],
      },
    },

    // ===================== SERVICE 3 =====================
    {
      "id": 103,
      "label": "Electrician",
      "slug": "electrician",
      "icon": Icons.electrical_services_rounded,
      "rating": 4.62,
      "bookings": "12K bookings",
      "items": [
        {"title": "Fan Install", "image": "assets/images/s1.png"},
        {"title": "Switch Repair", "image": "assets/images/s2.png"},
        {"title": "Wiring", "image": "assets/images/s3.png"},
      ],
      "topBannerSlides": [
        {
          "title": "Safe electrical service",
          "bullets": ["Certified electrician", "Hassle-free booking", "Warranty on service"],
          "image": "assets/images/service_ac_hero3.jpg",
        },
        {
          "title": "Quick fixes at home",
          "bullets": ["Verified professionals", "Tools included", "Transparent pricing"],
          "image": "assets/images/service_ac_hero2.jpg",
        },
      ],
      "packagesByItem": {
        0: [
          {
            "tag": "SAFE INSTALL",
            "title": "Ceiling Fan Installation",
            "rating": 4.68,
            "reviews": "1.2K reviews",
            "priceStr": "Starts at SAR 49",
            "priceInt": 49,
            "optionsText": "2 options",
            "cardTitle": "Flawless fan\ninstallation",
            "cardBullets": ["Tools included", "Clean finish", "Warranty on service"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Proper mounting & balancing", "No loose wiring, safety checked"],
            "description":
            "Professional ceiling fan installation including mounting, balancing, wiring checks and final testing for safe operation.",
            "howItWorks": [
              {"title": "Site check", "desc": "Check mounting point, ceiling strength and old wiring condition."},
              {"title": "Installation", "desc": "Mount fan securely and connect wiring with proper insulation."},
              {"title": "Testing", "desc": "Run fan at different speeds and ensure no wobble/noise."},
            ],
            "ratingBreakdown": {
              "average": "4.68",
              "total": "1,245 ratings",
              "counts": [900, 220, 70, 35, 20],
            },
          },
          {
            "tag": "MOST BOOKED",
            "title": "Exhaust Fan Installation",
            "rating": 4.64,
            "reviews": "780 reviews",
            "priceStr": "Starts at SAR 39",
            "priceInt": 39,
            "optionsText": "Add",
            "cardTitle": "Fresh air\nsetup",
            "cardBullets": ["Neat fitting", "Wire insulation", "Performance test"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Kitchen/Bath exhaust fan fitting", "Noise + airflow check included"],
            "description":
            "Exhaust fan installation with neat fitting, secure wiring and airflow testing to ensure smooth ventilation.",
            "howItWorks": [
              {"title": "Measurement", "desc": "Confirm cut-out size and placement for best airflow."},
              {"title": "Fix & wire", "desc": "Install fan unit and connect wiring safely with insulation."},
              {"title": "Test run", "desc": "Check airflow direction, noise level and power stability."},
            ],
            "ratingBreakdown": {
              "average": "4.64",
              "total": "782 ratings",
              "counts": [520, 170, 50, 25, 17],
            },
          },
          {
            "tag": "ADD-ON",
            "title": "Fan Regulator Installation",
            "rating": 4.61,
            "reviews": "640 reviews",
            "priceStr": "Starts at SAR 25",
            "priceInt": 25,
            "optionsText": "Add",
            "cardTitle": "Smooth speed\ncontrol",
            "cardBullets": ["Regulator fitting", "Speed calibration", "Safety check"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Regulator fitting & calibration", "Speed levels tested"],
            "description":
            "Install and calibrate fan regulator for smooth speed control. Includes safety inspection and speed-level testing.",
            "howItWorks": [
              {"title": "Switchboard check", "desc": "Check existing board space and wiring integrity."},
              {"title": "Regulator fit", "desc": "Install regulator and connect securely."},
              {"title": "Speed test", "desc": "Test all speed levels and ensure stable operation."},
            ],
            "ratingBreakdown": {
              "average": "4.61",
              "total": "648 ratings",
              "counts": [420, 150, 45, 18, 15],
            },
          },
        ],
        1: [
          {
            "tag": "REPAIR",
            "title": "Switch Repair (Single)",
            "rating": 4.66,
            "reviews": "2.3K reviews",
            "priceStr": "Starts at SAR 19",
            "priceInt": 19,
            "optionsText": "Add",
            "cardTitle": "Fix switch\nissues",
            "cardBullets": ["Loose contact fix", "Spark check", "Safety testing"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Fix loose/unstable switch", "Safety checks included"],
            "description":
            "Repair faulty switch issues like loose contact, sparking or intermittent power. Includes safety testing after fix.",
            "howItWorks": [
              {"title": "Diagnosis", "desc": "Check switch contact, wiring and load."},
              {"title": "Repair", "desc": "Tighten/replace contact points and secure wiring."},
              {"title": "Safety test", "desc": "Test power flow and confirm no sparks/heat."},
            ],
            "ratingBreakdown": {
              "average": "4.66",
              "total": "2,310 ratings",
              "counts": [1600, 450, 140, 70, 50],
            },
          },
          {
            "tag": "BESTSELLER",
            "title": "Socket Replacement",
            "rating": 4.63,
            "reviews": "1.1K reviews",
            "priceStr": "Starts at SAR 25",
            "priceInt": 25,
            "optionsText": "Add",
            "cardTitle": "New socket\nreplacement",
            "cardBullets": ["Proper fitting", "Load testing", "Clean finish"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Replace damaged/burnt socket", "Load test after installation"],
            "description":
            "Replace damaged/burnt socket with secure fitting and load testing for safe appliance use.",
            "howItWorks": [
              {"title": "Power off", "desc": "Turn off power and confirm no current flow."},
              {"title": "Replacement", "desc": "Install new socket with correct wiring and insulation."},
              {"title": "Load test", "desc": "Test with device/load to ensure stable supply."},
            ],
            "ratingBreakdown": {
              "average": "4.63",
              "total": "1,128 ratings",
              "counts": [760, 250, 75, 25, 18],
            },
          },
          {
            "tag": "POWER TRIP",
            "title": "MCB / Fuse Fix",
            "rating": 4.70,
            "reviews": "950 reviews",
            "priceStr": "Starts at SAR 35",
            "priceInt": 35,
            "optionsText": "Add",
            "cardTitle": "Stop power\ntrips",
            "cardBullets": ["Cause diagnosis", "Reset/replace (basic)", "Safety guidance"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Trip issue diagnosis", "Basic reset & fix included"],
            "description":
            "Fix frequent power trips by diagnosing overload/short issues. Includes basic reset & safe recommendations (spare parts extra if needed).",
            "howItWorks": [
              {"title": "Diagnosis", "desc": "Check load distribution and identify short/overload."},
              {"title": "Fix", "desc": "Reset MCB/fuse and secure loose connections."},
              {"title": "Final test", "desc": "Run test to confirm stability and no repeated trips."},
            ],
            "ratingBreakdown": {
              "average": "4.70",
              "total": "972 ratings",
              "counts": [700, 180, 55, 20, 17],
            },
          },
        ],
        2: [
          {
            "tag": "NEW WIRING",
            "title": "Light Point Installation",
            "rating": 4.69,
            "reviews": "1.4K reviews",
            "priceStr": "Starts at SAR 29",
            "priceInt": 29,
            "optionsText": "Add",
            "cardTitle": "New light\npoint setup",
            "cardBullets": ["Wire routing", "Switch mapping", "Testing included"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["New light point wiring setup", "Testing included"],
            "description":
            "Install a new light point with safe wire routing, switch mapping and final testing for stable illumination.",
            "howItWorks": [
              {"title": "Planning", "desc": "Confirm light location and route with minimal disturbance."},
              {"title": "Wiring", "desc": "Run wiring safely and connect to switchboard."},
              {"title": "Testing", "desc": "Test switch + voltage + proper illumination."},
            ],
            "ratingBreakdown": {
              "average": "4.69",
              "total": "1,420 ratings",
              "counts": [1040, 260, 70, 30, 20],
            },
          },
          {
            "tag": "ROOM WIRING",
            "title": "Room Wiring (Basic)",
            "rating": 4.62,
            "reviews": "540 reviews",
            "priceStr": "Starts at SAR 149",
            "priceInt": 149,
            "optionsText": "2 options",
            "cardTitle": "Safe wiring\nsetup",
            "cardBullets": ["Professional wiring", "Safety inspection", "Final load test"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Basic room wiring (scope based)", "Final load test included"],
            "description":
            "Basic room wiring setup (scope-based). Includes safety inspection and load testing after completion.",
            "howItWorks": [
              {"title": "Inspection", "desc": "Assess existing points and wiring needs."},
              {"title": "Execution", "desc": "Run wiring and connect points securely with insulation."},
              {"title": "Load test", "desc": "Test load stability and ensure safe operation."},
            ],
            "ratingBreakdown": {
              "average": "4.62",
              "total": "548 ratings",
              "counts": [360, 130, 35, 14, 9],
            },
          },
          {
            "tag": "BEST VALUE",
            "title": "Ceiling Light / Chandelier Setup",
            "rating": 4.67,
            "reviews": "880 reviews",
            "priceStr": "Starts at SAR 59",
            "priceInt": 59,
            "optionsText": "Add",
            "cardTitle": "Premium ceiling\nlighting",
            "cardBullets": ["Mounting included", "Secure connections", "Finish + testing"],
            "image": "assets/images/service_ac_hero.jpg",
            "shortDetails": ["Ceiling light/chandelier install", "Secure mounting & testing"],
            "description":
            "Install ceiling light or chandelier with secure mounting, proper connections and full testing for safety and stability.",
            "howItWorks": [
              {"title": "Mount check", "desc": "Check ceiling hook/plate and support strength."},
              {"title": "Install", "desc": "Mount fixture and connect wiring securely."},
              {"title": "Testing", "desc": "Check brightness, stability and heat/safety."},
            ],
            "ratingBreakdown": {
              "average": "4.67",
              "total": "892 ratings",
              "counts": [640, 180, 45, 15, 12],
            },
          },
        ],
      },
    },
  ].obs;

  void selectService(int index) => selectedServiceIndex.value = index;

  Map<String, dynamic> get selectedService => services[selectedServiceIndex.value];

  // ✅ NEW: open details (use from UI)
  void openServiceDetails(Map<String, dynamic> service) {
    Get.to(() => const ServiceDetailsView(), arguments: service);
  }

  // ✅ NEW: chip click shortcut
  void onServiceChipTap(int index) {
    selectService(index);
    openServiceDetails(services[index]);
  }
}
