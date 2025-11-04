import '../models/city_data.dart';

/// City-level rent and income data
class CityDataSource {
  /// Get city data organized by state
  /// Returns a map: state name -> city name -> CityData
  static Map<String, Map<String, CityData>> getCityDataMap() {
    final cities = getAllCities();
    final Map<String, Map<String, CityData>> result = {};
    
    for (final city in cities) {
      final stateName = _getStateNameFromAbbr(city.state);
      if (!result.containsKey(stateName)) {
        result[stateName] = {};
      }
      result[stateName]![city.name] = city;
    }
    
    return result;
  }

  /// Get all cities as a flat list
  static List<CityData> getAllCities() {
    return [
      // District of Columbia
      CityData(
        id: 'washington-dc',
        name: 'Washington',
        state: 'DC',
        fullName: 'Washington, DC',
        medianRent: 2200,
        medianIncome: 85000,
        isSpecialCase: true,
      ),
      
      // Alabama
      CityData(id: 'birmingham-al', name: 'Birmingham', state: 'AL', fullName: 'Birmingham, AL', medianRent: 950, medianIncome: 48000),
      CityData(id: 'montgomery-al', name: 'Montgomery', state: 'AL', fullName: 'Montgomery, AL', medianRent: 850, medianIncome: 45000),
      
      // Alaska
      CityData(id: 'anchorage-ak', name: 'Anchorage', state: 'AK', fullName: 'Anchorage, AK', medianRent: 1250, medianIncome: 62000),
      CityData(id: 'fairbanks-ak', name: 'Fairbanks', state: 'AK', fullName: 'Fairbanks, AK', medianRent: 1150, medianIncome: 58000),
      CityData(id: 'juneau-ak', name: 'Juneau', state: 'AK', fullName: 'Juneau, AK', medianRent: 1350, medianIncome: 65000),
      
      // Arizona
      CityData(id: 'phoenix-az', name: 'Phoenix', state: 'AZ', fullName: 'Phoenix, AZ', medianRent: 1350, medianIncome: 52000),
      CityData(id: 'tucson-az', name: 'Tucson', state: 'AZ', fullName: 'Tucson, AZ', medianRent: 1150, medianIncome: 48000),
      CityData(id: 'mesa-az', name: 'Mesa', state: 'AZ', fullName: 'Mesa, AZ', medianRent: 1250, medianIncome: 50000),
      
      // Arkansas
      CityData(id: 'little-rock-ar', name: 'Little Rock', state: 'AR', fullName: 'Little Rock, AR', medianRent: 850, medianIncome: 45000),
      CityData(id: 'fayetteville-ar', name: 'Fayetteville', state: 'AR', fullName: 'Fayetteville, AR', medianRent: 950, medianIncome: 48000),
      
      // California
      CityData(id: 'los-angeles-ca', name: 'Los Angeles', state: 'CA', fullName: 'Los Angeles, CA', medianRent: 2450, medianIncome: 52000),
      CityData(id: 'san-francisco-ca', name: 'San Francisco', state: 'CA', fullName: 'San Francisco, CA', medianRent: 3100, medianIncome: 70000),
      CityData(id: 'san-diego-ca', name: 'San Diego', state: 'CA', fullName: 'San Diego, CA', medianRent: 2450, medianIncome: 52000),
      CityData(id: 'san-jose-ca', name: 'San Jose', state: 'CA', fullName: 'San Jose, CA', medianRent: 2450, medianIncome: 52000),
      CityData(id: 'fresno-ca', name: 'Fresno', state: 'CA', fullName: 'Fresno, CA', medianRent: 1350, medianIncome: 48000),
      CityData(id: 'sacramento-ca', name: 'Sacramento', state: 'CA', fullName: 'Sacramento, CA', medianRent: 1650, medianIncome: 55000),
      CityData(id: 'oakland-ca', name: 'Oakland', state: 'CA', fullName: 'Oakland, CA', medianRent: 2200, medianIncome: 58000),
      CityData(id: 'long-beach-ca', name: 'Long Beach', state: 'CA', fullName: 'Long Beach, CA', medianRent: 1950, medianIncome: 52000),
      
      // Colorado
      CityData(id: 'denver-co', name: 'Denver', state: 'CO', fullName: 'Denver, CO', medianRent: 1650, medianIncome: 58000),
      CityData(id: 'colorado-springs-co', name: 'Colorado Springs', state: 'CO', fullName: 'Colorado Springs, CO', medianRent: 1350, medianIncome: 52000),
      CityData(id: 'aurora-co', name: 'Aurora', state: 'CO', fullName: 'Aurora, CO', medianRent: 1450, medianIncome: 55000),
      
      // Connecticut
      CityData(id: 'hartford-ct', name: 'Hartford', state: 'CT', fullName: 'Hartford, CT', medianRent: 1450, medianIncome: 62000),
      
      // Delaware
      CityData(id: 'wilmington-de', name: 'Wilmington', state: 'DE', fullName: 'Wilmington, DE', medianRent: 1250, medianIncome: 55000),
      
      // Florida
      CityData(id: 'miami-fl', name: 'Miami', state: 'FL', fullName: 'Miami, FL', medianRent: 1450, medianIncome: 48000),
      
      // Georgia
      CityData(id: 'atlanta-ga', name: 'Atlanta', state: 'GA', fullName: 'Atlanta, GA', medianRent: 1240, medianIncome: 56000),
      
      // Hawaii
      CityData(id: 'honolulu-hi', name: 'Honolulu', state: 'HI', fullName: 'Honolulu, HI', medianRent: 1950, medianIncome: 58000),
      
      // Idaho
      CityData(id: 'boise-id', name: 'Boise', state: 'ID', fullName: 'Boise, ID', medianRent: 1150, medianIncome: 48000),
      
      // Illinois
      CityData(id: 'chicago-il', name: 'Chicago', state: 'IL', fullName: 'Chicago, IL', medianRent: 1800, medianIncome: 55000),
      
      // Indiana
      CityData(id: 'indianapolis-in', name: 'Indianapolis', state: 'IN', fullName: 'Indianapolis, IN', medianRent: 950, medianIncome: 48000),
      
      // Iowa
      CityData(id: 'des-moines-ia', name: 'Des Moines', state: 'IA', fullName: 'Des Moines, IA', medianRent: 950, medianIncome: 48000),
      
      // Kansas
      CityData(id: 'wichita-ks', name: 'Wichita', state: 'KS', fullName: 'Wichita, KS', medianRent: 950, medianIncome: 48000),
      
      // Kentucky
      CityData(id: 'louisville-ky', name: 'Louisville', state: 'KY', fullName: 'Louisville, KY', medianRent: 850, medianIncome: 45000),
      
      // Louisiana
      CityData(id: 'new-orleans-la', name: 'New Orleans', state: 'LA', fullName: 'New Orleans, LA', medianRent: 950, medianIncome: 45000),
      
      // Maine
      CityData(id: 'portland-me', name: 'Portland', state: 'ME', fullName: 'Portland, ME', medianRent: 1150, medianIncome: 48000),
      
      // Maryland
      CityData(id: 'baltimore-md', name: 'Baltimore', state: 'MD', fullName: 'Baltimore, MD', medianRent: 1450, medianIncome: 62000),
      
      // Massachusetts
      CityData(id: 'boston-ma', name: 'Boston', state: 'MA', fullName: 'Boston, MA', medianRent: 1650, medianIncome: 65000),
      
      // Michigan
      CityData(id: 'detroit-mi', name: 'Detroit', state: 'MI', fullName: 'Detroit, MI', medianRent: 1050, medianIncome: 52000),
      
      // Minnesota
      CityData(id: 'minneapolis-mn', name: 'Minneapolis', state: 'MN', fullName: 'Minneapolis, MN', medianRent: 1250, medianIncome: 58000),
      
      // Mississippi
      CityData(id: 'jackson-ms', name: 'Jackson', state: 'MS', fullName: 'Jackson, MS', medianRent: 850, medianIncome: 42000),
      
      // Missouri
      CityData(id: 'st-louis-mo', name: 'St. Louis', state: 'MO', fullName: 'St. Louis, MO', medianRent: 950, medianIncome: 48000),
      
      // Montana
      CityData(id: 'billings-mt', name: 'Billings', state: 'MT', fullName: 'Billings, MT', medianRent: 1150, medianIncome: 48000),
      
      // Nebraska
      CityData(id: 'omaha-ne', name: 'Omaha', state: 'NE', fullName: 'Omaha, NE', medianRent: 950, medianIncome: 48000),
      
      // Nevada
      CityData(id: 'las-vegas-nv', name: 'Las Vegas', state: 'NV', fullName: 'Las Vegas, NV', medianRent: 1350, medianIncome: 52000),
      
      // New Hampshire
      CityData(id: 'manchester-nh', name: 'Manchester', state: 'NH', fullName: 'Manchester, NH', medianRent: 1250, medianIncome: 55000),
      
      // New Jersey
      CityData(id: 'jersey-city-nj', name: 'Jersey City', state: 'NJ', fullName: 'Jersey City, NJ', medianRent: 1650, medianIncome: 62000),
      
      // New Mexico
      CityData(id: 'albuquerque-nm', name: 'Albuquerque', state: 'NM', fullName: 'Albuquerque, NM', medianRent: 950, medianIncome: 45000),
      
      // New York
      CityData(id: 'new-york-ny', name: 'New York City', state: 'NY', fullName: 'New York City, NY', medianRent: 3200, medianIncome: 60000),
      
      // North Carolina
      CityData(id: 'charlotte-nc', name: 'Charlotte', state: 'NC', fullName: 'Charlotte, NC', medianRent: 1150, medianIncome: 52000),
      
      // North Dakota
      CityData(id: 'fargo-nd', name: 'Fargo', state: 'ND', fullName: 'Fargo, ND', medianRent: 850, medianIncome: 52000),
      
      // Ohio
      CityData(id: 'cleveland-oh', name: 'Cleveland', state: 'OH', fullName: 'Cleveland, OH', medianRent: 950, medianIncome: 48000),
      
      // Oklahoma
      CityData(id: 'oklahoma-city-ok', name: 'Oklahoma City', state: 'OK', fullName: 'Oklahoma City, OK', medianRent: 850, medianIncome: 45000),
      
      // Oregon
      CityData(id: 'portland-or', name: 'Portland', state: 'OR', fullName: 'Portland, OR', medianRent: 1350, medianIncome: 55000),
      
      // Pennsylvania
      CityData(id: 'philadelphia-pa', name: 'Philadelphia', state: 'PA', fullName: 'Philadelphia, PA', medianRent: 1150, medianIncome: 52000),
      
      // Rhode Island
      CityData(id: 'providence-ri', name: 'Providence', state: 'RI', fullName: 'Providence, RI', medianRent: 1250, medianIncome: 55000),
      
      // South Carolina
      CityData(id: 'charleston-sc', name: 'Charleston', state: 'SC', fullName: 'Charleston, SC', medianRent: 1050, medianIncome: 48000),
      
      // South Dakota
      CityData(id: 'sioux-falls-sd', name: 'Sioux Falls', state: 'SD', fullName: 'Sioux Falls, SD', medianRent: 850, medianIncome: 48000),
      
      // Tennessee
      CityData(id: 'nashville-tn', name: 'Nashville', state: 'TN', fullName: 'Nashville, TN', medianRent: 1150, medianIncome: 48000),
      
      // Texas
      CityData(id: 'austin-tx', name: 'Austin', state: 'TX', fullName: 'Austin, TX', medianRent: 1150, medianIncome: 52000),
      CityData(id: 'dallas-tx', name: 'Dallas', state: 'TX', fullName: 'Dallas, TX', medianRent: 1150, medianIncome: 52000),
      CityData(id: 'houston-tx', name: 'Houston', state: 'TX', fullName: 'Houston, TX', medianRent: 1150, medianIncome: 52000),
      CityData(id: 'san-antonio-tx', name: 'San Antonio', state: 'TX', fullName: 'San Antonio, TX', medianRent: 1150, medianIncome: 52000),
      CityData(id: 'fort-worth-tx', name: 'Fort Worth', state: 'TX', fullName: 'Fort Worth, TX', medianRent: 1150, medianIncome: 52000),
      CityData(id: 'plano-tx', name: 'Plano', state: 'TX', fullName: 'Plano, TX', medianRent: 1350, medianIncome: 58000),
      CityData(id: 'frisco-tx', name: 'Frisco', state: 'TX', fullName: 'Frisco, TX', medianRent: 1450, medianIncome: 62000),
      
      // Utah
      CityData(id: 'salt-lake-city-ut', name: 'Salt Lake City', state: 'UT', fullName: 'Salt Lake City, UT', medianRent: 1250, medianIncome: 52000),
      CityData(id: 'provo-ut', name: 'Provo', state: 'UT', fullName: 'Provo, UT', medianRent: 1150, medianIncome: 48000),
      
      // Vermont
      CityData(id: 'burlington-vt', name: 'Burlington', state: 'VT', fullName: 'Burlington, VT', medianRent: 1250, medianIncome: 52000),
      CityData(id: 'montpelier-vt', name: 'Montpelier', state: 'VT', fullName: 'Montpelier, VT', medianRent: 1150, medianIncome: 48000),
      
      // Virginia
      CityData(id: 'arlington-va', name: 'Arlington', state: 'VA', fullName: 'Arlington, VA', medianRent: 1350, medianIncome: 58000),
      CityData(id: 'virginia-beach-va', name: 'Virginia Beach', state: 'VA', fullName: 'Virginia Beach, VA', medianRent: 1250, medianIncome: 55000),
      CityData(id: 'richmond-va', name: 'Richmond', state: 'VA', fullName: 'Richmond, VA', medianRent: 1150, medianIncome: 52000),
      
      // Washington
      CityData(id: 'seattle-wa', name: 'Seattle', state: 'WA', fullName: 'Seattle, WA', medianRent: 1450, medianIncome: 62000),
      CityData(id: 'spokane-wa', name: 'Spokane', state: 'WA', fullName: 'Spokane, WA', medianRent: 1150, medianIncome: 52000),
      CityData(id: 'vancouver-wa', name: 'Vancouver', state: 'WA', fullName: 'Vancouver, WA', medianRent: 1250, medianIncome: 55000),
      
      // West Virginia
      CityData(id: 'charleston-wv', name: 'Charleston', state: 'WV', fullName: 'Charleston, WV', medianRent: 850, medianIncome: 42000),
      CityData(id: 'morgantown-wv', name: 'Morgantown', state: 'WV', fullName: 'Morgantown, WV', medianRent: 950, medianIncome: 45000),
      
      // Wisconsin
      CityData(id: 'milwaukee-wi', name: 'Milwaukee', state: 'WI', fullName: 'Milwaukee, WI', medianRent: 1050, medianIncome: 52000),
      CityData(id: 'madison-wi', name: 'Madison', state: 'WI', fullName: 'Madison, WI', medianRent: 1150, medianIncome: 55000),
      
      // Wyoming
      CityData(id: 'cheyenne-wy', name: 'Cheyenne', state: 'WY', fullName: 'Cheyenne, WY', medianRent: 950, medianIncome: 52000),
      CityData(id: 'casper-wy', name: 'Casper', state: 'WY', fullName: 'Casper, WY', medianRent: 850, medianIncome: 48000),
    ];
  }

  static String _getStateNameFromAbbr(String abbr) {
    // This will be replaced with proper state mapping lookup
    final mapping = {
      'AL': 'Alabama', 'AK': 'Alaska', 'AZ': 'Arizona', 'AR': 'Arkansas',
      'CA': 'California', 'CO': 'Colorado', 'CT': 'Connecticut', 'DE': 'Delaware',
      'DC': 'District of Columbia', 'FL': 'Florida', 'GA': 'Georgia',
      'HI': 'Hawaii', 'ID': 'Idaho', 'IL': 'Illinois', 'IN': 'Indiana',
      'IA': 'Iowa', 'KS': 'Kansas', 'KY': 'Kentucky', 'LA': 'Louisiana',
      'ME': 'Maine', 'MD': 'Maryland', 'MA': 'Massachusetts', 'MI': 'Michigan',
      'MN': 'Minnesota', 'MS': 'Mississippi', 'MO': 'Missouri', 'MT': 'Montana',
      'NE': 'Nebraska', 'NV': 'Nevada', 'NH': 'New Hampshire', 'NJ': 'New Jersey',
      'NM': 'New Mexico', 'NY': 'New York', 'NC': 'North Carolina', 'ND': 'North Dakota',
      'OH': 'Ohio', 'OK': 'Oklahoma', 'OR': 'Oregon', 'PA': 'Pennsylvania',
      'RI': 'Rhode Island', 'SC': 'South Carolina', 'SD': 'South Dakota',
      'TN': 'Tennessee', 'TX': 'Texas', 'UT': 'Utah', 'VT': 'Vermont',
      'VA': 'Virginia', 'WA': 'Washington', 'WV': 'West Virginia',
      'WI': 'Wisconsin', 'WY': 'Wyoming',
    };
    return mapping[abbr.toUpperCase()] ?? abbr;
  }
}

