import 'package:surgerychkd/SURGERY.dart';
import 'package:intl/intl.dart';

class surgeryVariable {
  static var surgery = new Map();
  static var patientSurgery = [];
  static var finalArr = [];
  static var surgeryDetails = {
    'Orthopedic Surgery': {
      'procedure': [
        [
          'Description',
          '''A fracture is a broken bone.Fractures usually heal in 6 to 8 weeks. Healing time can vary from person to person. Closed reduction is a surgery to set or reduce a broken bone or bones. This allows the bone to grow back together.'''
        ],
      ],
      'prepare': [
        [
          'The Week Before ',
          '''Is your child taking any of the following medicines? If yes, please discuss them with your surgeon before and after surgery:
Aspirin
Coumadin®
Celebrex®
Ibuprofen (Advil®, Motrin®)
Naprosyn (Aleve®)
Plavix®
Some over the counter herbs (chondroitin, dan shen, feverfew, garlic tablets, ginger tablets, ginkgo, ginseng and quilinggao and fish oil)
'''
        ],
        [
          'The Night Before',
          '''Make sure your child takes a bath or shower and be sure to shampoo hair.
After bathing, dress your child in freshly washed pajamas. Put clean sheets on the bed. These are important steps to help prevent infection.
Make sure your child removes all nail polish, artificial nails, jewelry and make-up.
'''
        ],
        [
          'The Day Of Procedure',
          '''Have your child brush their teeth using water only. No toothpaste.
Place your child’s hair in a ponytail or pigtails. No metal in hair ties or fasteners.
Park in the parking lot and come directly into the main entrance of the building. Our Guest Services team will direct you to the Surgery/Procedure Center in Suite 1E.
Check in at the registration desk and have a seat in our waiting area. A nurse will walk you to a private room in the preoperative area. Please limit the number of visitors with each patient.
The surgical team will meet with you and talk about your child’s procedure and anesthesia plan.
Your child may need an IV before surgery. Numbing medicine is used to start the IV. See the  IV insertion video. A Child Life Specialist will be available to patients and families. They develop ways to cope with fear, anxiety, and separation by using play, music, art, and education techniques.
Your child may receive a patch to prevent nausea or vomiting. It is placed behind the ear. You will be instructed to remove patch on the 3rd day after surgery.
Before the procedure, girls 9 years of age and older may be asked to give a urine sample for pregnancy screening.
'''
        ]
      ],
      'visit': [
        [
          'During the Procedure',
          '''Parents and family members are welcome to wait in our waiting room.
During the procedure, updates will be sent via message through the App.
After surgery, your child will return to a room and be monitored closely.
Your child’s doctor will talk with you about the procedure and recovery time in a consult room. After, you will return to the waiting area until you’re called to the recovery area.
Most children spend about an hour at the CSCC after their procedure. Some children may stay longer based on recovery time and procedure.
'''
        ],
        [
          'Questions to ask your surgeon after the procedure:',
          '''When should the dressing be removed?
When can my child bathe, shower, or swim?
What is my child's weight-bearing status?
Will my child be using crutches? For how long? This crutch training video may be useful.
Will my child require physical therapy?
When can my child return to school/daycare?
When can my child return to gym/recess/contact sports?
When can my teenager drive?'''
        ]
      ],
      'home care': [
        [
          'Swelling',
          '''Swelling can happen after surgery. You can use pillows to elevate your child's leg/foot so the surgical site is above the level of the heart. Do this as much as possible to reduce the swelling and pain after surgery.
Apply a waterproof ice pack over your child's dressing/splint for 20 minutes each hour for the first few days while awake. This will also help reduce swelling and pain.
'''
        ],
        [
          'Pain Medicine',
          '''Pain is a normal part of the recovery after surgery. The pain medicine given to your child will help to reduce the pain, but will not completely eliminate it.
Remember to elevate your child's leg/foot (as instructed above), if your child has pain.
Pain should decrease over the first few days after surgery. This will allow your child to:
take less pain medicine or
stop taking all pain medicine or
increase the time between doses of pain medicine.
Requests for prescription refills must be called to the office (NOT the medical exchange service) on Monday-Friday from 8:00-4:00, excluding holidays.
'''
        ],
        [
          'Diet',
          ''' Start with a light diet once you are home after surgery. Then continue with usual diet.
'''
        ],
        [
          'Activities',
          '''Resting the foot lessens swelling and allows the injury to heal.
As your child becomes more active, you may see swelling in his or her toes again. Apply ice and elevate.
Follow the surgeon’s instructions for return to school/daycare and gym class/sports.
'''
        ],
        [
          'Dressing/Wound Care',
          '''Keep the dressing, cast or splint dry. Cover it with a plastic bag when your child bathes or showers. Try to make the wrapping water-tight.
Follow the surgeon’s instructions regarding dressing/splint/cast care, bathing and/or showering.
'''
        ],
        [
          'Cast Care (if applicable)',
          '''Check the skin around the cast every day.
Do not remove the cast yourself. Your child's doctor will remove the cast with a special tool when it is time to take the cast off.
Do not break off rough edges of the cast or trim the cast.
Do not put any objects inside the cast to scratch.
Do not apply powders or deodorants to itchy skin.
'''
        ],
        [
          'When to Be Concerned',
          '''For Emergencies, Call 911\nFor Non-emergencies (such as the symptoms listed below):
  Call (314) 454-3250 during weekdays, between 7:00 am and 4:00 pm.
  Call (314) 454-6000 after 4:00 pm weekdays and on weekends. Ask for the Orthopedic resident on call.''',
        ],
        [
          'Follow Up',
          '''Call the Orthopedic office at (314) 454-2500 to schedule a follow-up visit. Physical therapy and driving instructions will be discussed at this visit.
'''
        ]
      ],
    },
    'Inguinal Hernia': {
      'procedure': [
        [
          'Description',
          '''Blocked tear ducts are common in babies. Many children are born with immature tear ducts. This can lead to overflow tearing and infection. The tear duct may open on its own by the time your child is 6 months old. If the symptoms last after 6 months of age, your child may need to see a pediatric eye doctor for a procedure to open the duct.'''
        ]
      ],
      'prepare': [
        [
          'The Night Before',
          '''Make sure your child takes a bath or shower and be sure to shampoo hair.
After bathing, dress your child in freshly washed pajamas. Put clean sheets on the bed. These are important steps to help prevent infection.
Make sure your child removes all nail polish, artificial nails, jewelry and make-up.
''',
        ],
        [
          'The Day Of Procedure',
          '''Have your child brush their teeth using water only. No toothpaste.
Place your child’s hair in a ponytail or pigtails. No metal in hair ties or fasteners.
Park in the parking lot and come directly into the main entrance of the building. Our Guest Services team will direct you to the Surgery/Procedure Center in Suite 1E.
Check in at the registration desk and have a seat in our waiting area. A nurse will walk you to a private room in the preoperative area. Please limit the number of visitors with each patient.
The surgical team will meet with you and talk about your child’s procedure and anesthesia plan.
Your child may need an IV before surgery. Numbing medicine is used to start the IV. See the  IV insertion video. A Child Life Specialist will be available to patients and families. They develop ways to cope with fear, anxiety, and separation by using play, music, art, and education techniques.
Before the procedure, girls 9 years of age and older may be asked to give a urine sample for pregnancy screening.
'''
        ],
      ],
      'visit': [
        [
          'During the Procedure',
          '''Parents and family members are welcome to wait in our waiting room.
During the procedure, updates will be sent via message through the App.
After surgery, your child will return to a room and be monitored closely.
Your child’s doctor will talk with you about the procedure and recovery time in a consult room. After, you will return to the waiting area until you’re called to the recovery area. Most children spend about an hour at the CSCC after their procedure. Some children may stay longer based on recovery time and procedure.
'''
        ],
      ],
      'home care': [
        [
          'Pain',
          '''Acetaminophen (Tylenol) can be given. See the Acetaminophen (Tylenol) Dosage Table. Ibuprofen (Motrin/Advil) can be given if your child is 6 months of age or older. See the Ibuprofen (Motrin/Advil) Dosage Table. Alternate Acetaminophen and Ibuprofen for the first 24 hours as directed by your child's doctor. Caution: Acetaminophen (Tylenol) can be found in many prescriptions and over-the-counter medicines. Read the labels to be sure your child is not getting it from 2 products. If you have questions, call your child’s doctor. Do not give more than 5 doses of acetaminophen (Tylenol) in 24 hours.'''
        ],
        [
          'Bleeding',
          '''It is common to have some bloody tears or bloody drainage from the nose for the first two days after surgery.
'''
        ],
        [
          'How to give eye ointment:',
          '''Clean your child’s eye of drainage and old medicine, if necessary. Use a clean damp gauze or cotton pad.
Wash your hands well with soap and water. Scrub for at least 10 to 15 seconds.
Warm the medicine by holding the ointment between your hands.
Tilt your child's head back and to the side of the eye you will be putting the medicine.
Do not touch the tip of the ointment container to the eye, the lid or other skin.
If your child is awake, gently pull down the lower lid and squeeze in the ordered amount of ointment. It will then melt and get everywhere on its own.
Your child may be unable to keep the eye open or is asleep while you are putting ointment in. In this case, put a thin layer of the ointment across the upper lash line (where the lashes meet the lid). The medicine will melt and get into the eye.
'''
        ],
        [
          'When to Be Concerned',
          '''For Emergencies, Call 911\nFor Non-emergencies (such as the symptoms listed below):
  Call (314) 454-3250 during weekdays, between 7:00 am and 4:00 pm.
  Call (314) 454-6000 after 4:00 pm weekdays and on weekends. Ask for the Orthopedic resident on call.''',
        ],
        [
          'Follow Up',
          '''Call the Eye Center at (314) 454-6026 to schedule a follow-up visit, if instructed by the surgeon.'''
        ]
      ]
    },
    'Adenotonsillectomy': {
      'procedure': [
        [
          'Description',
          '''Tonsils are small, oval pieces of tissue that are located in the back of the mouth. They are thought to help fight infections. [image]
Adenoids are similar to tonsils. They are located in the space above the soft roof of the mouth. They cannot be seen by looking in your child’s nose or throat. Adenoids also help to fight infections, but may cause problems if they become swollen or infected. 
'''
        ]
      ],
      'prepare': [
        [
          'The Night Before',
          '''Make sure your child takes a bath or shower and be sure to shampoo hair.
After bathing, dress your child in freshly washed pajamas. Put clean sheets on the bed. These are important steps to help prevent infection.
Make sure your child removes all nail polish, artificial nails, jewelry and make-up.
'''
        ],
        [
          'The Day Of Procedure',
          '''Have your child brush their teeth using water only. No toothpaste.
Place your child’s hair in a ponytail or pigtails. No metal in hair ties or fasteners.
Park in the parking lot and come directly into the main entrance of the building. Our Guest Services team will direct you to the Surgery/Procedure Center in Suite 1E.
Check in at the registration desk and have a seat in our waiting area. A nurse will walk you to a private room in the preoperative area. Please limit the number of visitors with each patient.
The surgical team will meet with you and talk about your child’s procedure and anesthesia plan.
Your child may need an IV before surgery. Numbing medicine is used to start the IV. See the  IV insertion video. A Child Life Specialist will be available to patients and families. They develop ways to cope with fear, anxiety, and separation by using play, music, art, and education techniques.
Before the procedure, girls 9 years of age and older may be asked to give a urine sample for pregnancy screening.
'''
        ]
      ],
      'visit': [
        [
          'During the Procedure',
          '''Parents and family members are welcome to wait in our waiting room.
During the procedure, updates will be sent via message through the App.
After surgery, your child will return to a room and be monitored closely.
Your child’s doctor will talk with you about the procedure and recovery time in a consult room. After, you will return to the waiting area until you’re called to the recovery area.
Most children spend about an hour at the CSCC after their procedure. Some children may stay longer based on recovery time and procedure.
'''
        ]
      ],
      'home care': [
        [
          'Pain',
          '''Acetaminophen (Tylenol) can be given. See the Acetaminophen (Tylenol) Dosage Table. An ice bag to the neck may also be used for pain. Caution: Acetaminophen (Tylenol) can be found in many prescriptions and over-the-counter medicines. Read the labels to be sure your child is not getting it from 2 products. If you have questions, call your child’s doctor. Do not give more than 5 doses of acetaminophen (Tylenol) in 24 hours.
'''
        ],
        [
          'Encourage soft diet',
          '''Eggs, pancakes, pasta or noodles, well ground hamburger, pudding, or mashed potatoes. Chew things well and swallow slowly. If vomiting occurs, encourage liquids. Then move on to soft diet. It is important for your child to drink liquids, even if he or she doesn’t feel like eating.'''
        ],
        [
          'Activity',
          'Quiet play today. May return to school in 5 to 7 days and no sports or gym for 14 days. Avoid nose blowing until follow-up. If your child plays a wind/brass instrument, do not allow it until follow up.'
        ],
        [
          'When to Be Concerned',
          '''For Emergencies, Call 911\nFor Non-emergencies (such as the symptoms listed below):
  Call (314) 454-3250 during weekdays, between 7:00 am and 4:00 pm.
  Call (314) 454-6000 after 4:00 pm weekdays and on weekends. Ask for the Orthopedic resident on call.''',
        ],
        [
          'Follow Up',
          '''Call the Eye Center at (314) 454-6026 to schedule a follow-up visit, if instructed by the surgeon.'''
        ]
      ]
    }
  };
  surgeryVariable(
      String sn,
      String d,
      String t,
      String pid,
      String na,
      String a,
      String venue,
      String presc,
      String instr,
      String surgeon,
      String dateTime) {
//    DateTime date = DateFormat.jm().parse(t);
//    print(DateFormat("HH:mm").format(date));
//    var newTime = DateFormat("HH:mm").format(date);
    var arr = List();
    arr.add(sn);
    arr.add(t);
    arr.add(pid);
    arr.add(na);
    arr.add(a);
    arr.add(d);
    arr.add(venue);
    arr.add(presc);
    arr.add(instr);
    arr.add(surgeon);
    arr.add(dateTime);
//    if ((t.substring(6, 8)) == 'pm') {
//      var x = int.parse(t.substring(0, 2)) + 12;
//      var tempTime = x.toString() + t.substring(2, 5);
//      print(tempTime);
//    } else {
//      var tempTime = t.substring(0, 5);
//      print(tempTime);
//    }
    //adding to surgery variable, i.e is the calendar menu
    if (surgery.containsKey(d) == false) {
      var arr2 = List();
      arr2.add(arr);
      surgery[d] = arr2;
    } else {
      var arr2 = surgery[d];
      arr2.add(arr);
      surgery[d] = arr2;
    }
    print(pid);
//    if (patientSurgery.containsKey(pid) == false) {
//      var arr2 = List();
//      arr2.add(arr);
//      finalArr.add(arr);
//      dateSort();
//      patientSurgery[pid] = arr2;
//    } else {
//      var arr2 = patientSurgery[pid];
//      arr2.add(arr);
//      finalArr.add(arr);
//      dateSort();
//      patientSurgery[pid] = arr2;
//    }

    print(patientSurgery);
  }

  dateSort() {
    for (var i = 0; i < finalArr.length; i++) {
      for (var j = 0; j < finalArr.length - i - 1; j++) {
        int compVal = finalArr[j][10].compareTo(finalArr[j + 1][10]);
        if (compVal == 1) {
          var temp = finalArr[j];
          finalArr[j] = finalArr[j + 1];
          finalArr[j + 1] = temp;
        }
      }
    }
  }
}
