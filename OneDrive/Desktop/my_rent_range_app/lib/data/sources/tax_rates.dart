/// Tax rates for all 50 US states + DC
/// Values are decimal rates (e.g., 0.05 = 5%)
class TaxRates {
  static const Map<String, double> rates = {
    'AL': 0.05,
    'AK': 0.00,
    'AZ': 0.045,
    'AR': 0.065,
    'CA': 0.09,
    'CO': 0.0455,
    'CT': 0.05,
    'DE': 0.052,
    'FL': 0.00,
    'GA': 0.0575,
    'HI': 0.08,
    'ID': 0.06,
    'IL': 0.0495,
    'IN': 0.0323,
    'IA': 0.06,
    'KS': 0.057,
    'KY': 0.05,
    'LA': 0.06,
    'ME': 0.0715,
    'MD': 0.0475,
    'MA': 0.05,
    'MI': 0.0425,
    'MN': 0.068,
    'MS': 0.05,
    'MO': 0.054,
    'MT': 0.0675,
    'NE': 0.0684,
    'NV': 0.00,
    'NH': 0.00,
    'NJ': 0.0637,
    'NM': 0.049,
    'NY': 0.0649,
    'NC': 0.0525,
    'ND': 0.0227,
    'OH': 0.0399,
    'OK': 0.05,
    'OR': 0.09,
    'PA': 0.0307,
    'RI': 0.0599,
    'SC': 0.07,
    'SD': 0.00,
    'TN': 0.00,
    'TX': 0.00,
    'UT': 0.0495,
    'VT': 0.068,
    'VA': 0.0575,
    'WA': 0.00,
    'WV': 0.065,
    'WI': 0.053,
    'WY': 0.00,
    'DC': 0.085, // District of Columbia
  };

  /// Get tax rate for a state abbreviation
  static double getRate(String stateAbbr) {
    return rates[stateAbbr.toUpperCase()] ?? 0.05;
  }
}

