enum BloodType {
  aPositive('A+'),
  aNegative('A-'),
  bPositive('B+'),
  bNegative('B-'),
  abPositive('AB+'),
  abNegative('AB-'),
  oPositive('O+'),
  oNegative('O-');

  final String symbol;
  const BloodType(this.symbol);
}

enum ChronicDisease {
  diabetes('Diabetes'),
  hypertension('Hypertension'),
  asthma('Asthma'),
  heartDisease('Heart Disease'),
  arthritis('Arthritis'),
  cancer('Cancer'),
  kidneyDisease('Kidney Disease'),
  liverDisease('Liver Disease'),
  thyroidDisorder('Thyroid Disorder'),
  none('None');

  final String name;
  const ChronicDisease(this.name);
}

enum Allergy {
  penicillin('Penicillin'),
  sulfa('Sulfa Drugs'),
  aspirin('Aspirin'),
  ibuprofen('Ibuprofen'),
  peanuts('Peanuts'),
  shellfish('Shellfish'),
  eggs('Eggs'),
  dairy('Dairy'),
  pollen('Pollen'),
  dust('Dust'),
  petDander('Pet Dander'),
  none('None');

  final String name;
  const Allergy(this.name);
}

enum CurrentMedication {
  insulin('Insulin'),
  metformin('Metformin'),
  lisinopril('Lisinopril'),
  amlodipine('Amlodipine'),
  atorvastatin('Atorvastatin'),
  aspirin('Aspirin'),
  warfarin('Warfarin'),
  levothyroxine('Levothyroxine'),
  albuterol('Albuterol'),
  none('None');

  final String name;
  const CurrentMedication(this.name);
}
