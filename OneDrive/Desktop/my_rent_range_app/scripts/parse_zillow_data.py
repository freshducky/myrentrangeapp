#!/usr/bin/env python3
"""
Parse Zillow ZHVI CSV and extract latest rent estimates
Converts home values to rent estimates using standard conversion ratios
"""

import csv
import json
from pathlib import Path
from datetime import datetime

# Zillow CSV path
CSV_PATH = r"C:\Users\kturn\OneDrive\Desktop\Metro_zhvi_uc_sfrcondo_tier_0.33_0.67_sm_sa_month.csv"

# Conversion ratio: Rent typically ~0.5-0.7% of home value per month
# Using 0.55% as realistic estimate (annual rent = 6.6% of home value)
# This accounts for ZHVI being home values, not rent, and uses market standard ratios
RENT_TO_HOME_VALUE_RATIO = 0.0055

def get_latest_columns(header_row):
    """Extract the latest 6 months of data columns for trend calculation"""
    date_columns = [col for col in header_row if col and '-' in col]
    date_columns.sort(reverse=True)
    return date_columns[:6]  # Last 6 months

def parse_zillow_csv():
    """Parse Zillow CSV and extract metro data"""
    metro_data = {}
    
    with open(CSV_PATH, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        header = reader.fieldnames
        
        # Get latest date columns
        latest_cols = get_latest_columns(header)
        print(f"Latest columns: {latest_cols[:3]}...")
        
        for row in reader:
            region_name = row.get('RegionName', '').strip()
            state = row.get('StateName', '').strip()
            
            if not region_name or not state:
                continue
            
            # Get latest values
            values = []
            for col in latest_cols:
                val = row.get(col, '').strip()
                if val:
                    try:
                        values.append(float(val))
                    except ValueError:
                        pass
            
            if not values:
                continue
            
            # Calculate average of last 3 months (most recent data)
            latest_value = sum(values[:3]) / len(values[:3]) if values[:3] else values[0]
            
            # Calculate trend (comparing last 3 months vs previous 3 months)
            trend = 'stable'
            if len(values) >= 6:
                recent_avg = sum(values[:3]) / 3
                previous_avg = sum(values[3:6]) / 3
                change_pct = ((recent_avg - previous_avg) / previous_avg) * 100
                
                if change_pct > 2:
                    trend = 'up'
                elif change_pct < -2:
                    trend = 'down'
            
            # Convert home value to rent estimate
            rent_estimate = latest_value * RENT_TO_HOME_VALUE_RATIO
            
            metro_data[region_name] = {
                'region_name': region_name,
                'state': state,
                'home_value': latest_value,
                'rent_estimate': round(rent_estimate, 0),
                'trend': trend,
                'last_updated': latest_cols[0] if latest_cols else '2024-12-31',
            }
    
    return metro_data

def create_city_mapping():
    """Create mapping from Zillow metro names to our city names"""
    mapping = {
        # Major metros
        'New York, NY': 'New York City',
        'Los Angeles, CA': 'Los Angeles',
        'Chicago, IL': 'Chicago',
        'Dallas, TX': 'Dallas',
        'Houston, TX': 'Houston',
        'Phoenix, AZ': 'Phoenix',
        'Philadelphia, PA': 'Philadelphia',
        'San Antonio, TX': 'San Antonio',
        'San Diego, CA': 'San Diego',
        'San Jose, CA': 'San Jose',
        'Austin, TX': 'Austin',
        'Jacksonville, FL': 'Jacksonville',
        'Fort Worth, TX': 'Fort Worth',
        'Columbus, OH': 'Columbus',
        'Charlotte, NC': 'Charlotte',
        'San Francisco, CA': 'San Francisco',
        'Indianapolis, IN': 'Indianapolis',
        'Seattle, WA': 'Seattle',
        'Denver, CO': 'Denver',
        'Washington, DC': 'Washington',
        'Boston, MA': 'Boston',
        'El Paso, TX': 'El Paso',
        'Detroit, MI': 'Detroit',
        'Nashville, TN': 'Nashville',
        'Portland, OR': 'Portland',
        'Memphis, TN': None,  # Not in our list
        'Oklahoma City, OK': 'Oklahoma City',
        'Las Vegas, NV': 'Las Vegas',
        'Louisville, KY': 'Louisville',
        'Baltimore, MD': 'Baltimore',
        'Milwaukee, WI': 'Milwaukee',
        'Albuquerque, NM': 'Albuquerque',
        'Tucson, AZ': 'Tucson',
        'Fresno, CA': 'Fresno',
        'Sacramento, CA': 'Sacramento',
        'Kansas City, MO': None,  # Not in our list
        'Mesa, AZ': 'Mesa',
        'Atlanta, GA': 'Atlanta',
        'Omaha, NE': 'Omaha',
        'Colorado Springs, CO': 'Colorado Springs',
        'Raleigh, NC': 'Raleigh',
        'Virginia Beach, VA': 'Virginia Beach',
        'Miami, FL': 'Miami',
        'Oakland, CA': 'Oakland',
        'Minneapolis, MN': 'Minneapolis',
        'Tulsa, OK': None,  # Not in our list
        'Cleveland, OH': 'Cleveland',
        'Wichita, KS': 'Wichita',
        'Arlington, TX': None,  # Not in our list
        'Tampa, FL': 'Tampa',
        'New Orleans, LA': 'New Orleans',
        'Honolulu, HI': 'Honolulu',
        'Aurora, CO': 'Aurora',
        'Santa Ana, CA': None,  # Not in our list
        'St. Louis, MO': 'St. Louis',
        'Riverside, CA': None,  # Not in our list
        'Corpus Christi, TX': 'Corpus Christi',
        'Lexington, KY': None,  # Not in our list
        'Pittsburgh, PA': 'Pittsburgh',
        'Anchorage, AK': 'Anchorage',
        'Stockton, CA': None,  # Not in our list
        'Cincinnati, OH': 'Cincinnati',
        # St. Paul, MN - Part of Minneapolis-St. Paul metro, not separate
        'Toledo, OH': None,  # Not in our list
        'Greensboro, NC': None,  # Not in our list
        'Newark, NJ': None,  # Not in our list
        'Plano, TX': 'Plano',
        'Henderson, NV': None,  # Not in our list
        'Lincoln, NE': None,  # Not in our list
        'Buffalo, NY': 'Buffalo',
        'Albany, NY': 'Albany',
        'Jersey City, NJ': 'Jersey City',
        'Tacoma, WA': 'Tacoma',
        'Scottsdale, AZ': 'Scottsdale',
        'Reno, NV': 'Reno',
        'St. Paul, MN': 'St. Paul',
        'Anaheim, CA': 'Anaheim',
        'Chula Vista, CA': None,  # Not in our list
        'Fort Wayne, IN': None,  # Not in our list
        'Orlando, FL': 'Orlando',
        'St. Petersburg, FL': None,  # Not in our list
        'Chandler, AZ': None,  # Not in our list
        'Laredo, TX': None,  # Not in our list
        'Norfolk, VA': None,  # Not in our list
        'Durham, NC': None,  # Not in our list
        'Madison, WI': 'Madison',
        'Lubbock, TX': None,  # Not in our list
        'Irvine, CA': None,  # Not in our list
        'Winston-Salem, NC': None,  # Not in our list
        'Glendale, AZ': None,  # Not in our list
        'Garland, TX': None,  # Not in our list
        'Hialeah, FL': None,  # Not in our list
        'Reno, NV': 'Reno',
        'Chesapeake, VA': None,  # Not in our list
        'Gilbert, AZ': None,  # Not in our list
        'Baton Rouge, LA': None,  # Not in our list
        'Irving, TX': None,  # Not in our list
        # Scottsdale, AZ - Part of Phoenix metro, not separate
        'North Las Vegas, NV': None,  # Not in our list
        'Fremont, CA': None,  # Not in our list
        'Boise, ID': 'Boise',
        'Richmond, VA': 'Richmond',
        'San Bernardino, CA': None,  # Not in our list
        'Birmingham, AL': 'Birmingham',
        'Spokane, WA': 'Spokane',
        'Rochester, NY': None,  # Not in our list
        'Des Moines, IA': 'Des Moines',
        'Modesto, CA': None,  # Not in our list
        'Fayetteville, NC': None,  # Not in our list
        # Tacoma, WA - Part of Seattle-Tacoma metro, not separate
        'Oxnard, CA': None,  # Not in our list
        'Fontana, CA': None,  # Not in our list
        'Moreno Valley, CA': None,  # Not in our list
        'Shreveport, LA': None,  # Not in our list
        'Aurora, IL': None,  # Not in our list
        'Yonkers, NY': None,  # Not in our list
        'Akron, OH': None,  # Not in our list
        'Huntington Beach, CA': None,  # Not in our list
        'Little Rock, AR': 'Little Rock',
        'Augusta, GA': None,  # Not in our list
        'Amarillo, TX': None,  # Not in our list
        'Grand Rapids, MI': None,  # Not in our list
        'Mobile, AL': None,  # Not in our list
        'Salt Lake City, UT': 'Salt Lake City',
        'Tallahassee, FL': None,  # Not in our list
        'Grand Prairie, TX': None,  # Not in our list
        'Overland Park, KS': None,  # Not in our list
        'Cape Coral, FL': None,  # Not in our list
        'Santa Clarita, CA': None,  # Not in our list
        'Providence, RI': 'Providence',
        'Vancouver, WA': 'Vancouver',
        'Sioux Falls, SD': 'Sioux Falls',
        'Peoria, AZ': None,  # Not in our list
        'Ontario, CA': None,  # Not in our list
        'Eugene, OR': None,  # Not in our list
        'Ventura, CA': None,  # Not in our list
        'Chattanooga, TN': None,  # Not in our list
        'Brownsville, TX': None,  # Not in our list
        'Fort Lauderdale, FL': None,  # Not in our list
        'Tempe, AZ': None,  # Not in our list
        'Huntsville, AL': None,  # Not in our list
        'Springfield, MO': None,  # Not in our list
        'Santa Rosa, CA': None,  # Not in our list
        'Gainesville, FL': None,  # Not in our list
        'Vallejo, CA': None,  # Not in our list
        'Cary, NC': None,  # Not in our list
        'Frisco, TX': 'Frisco',
        'McKinney, TX': None,  # Not in our list
        'Santa Ana, CA': None,  # Not in our list
        'Fullerton, CA': None,  # Not in our list
        'Palm Bay, FL': None,  # Not in our list
        'Pomona, CA': None,  # Not in our list
        'Pasadena, CA': None,  # Not in our list
        'Hayward, CA': None,  # Not in our list
        'Salem, OR': None,  # Not in our list
        'Corona, CA': None,  # Not in our list
        'Escondido, CA': None,  # Not in our list
        'Kansas City, KS': None,  # Not in our list
        'Torrance, CA': None,  # Not in our list
        'Sterling Heights, MI': None,  # Not in our list
        'Murfreesboro, TN': None,  # Not in our list
        'Pembroke Pines, FL': None,  # Not in our list
        'Concord, CA': None,  # Not in our list
        'Roseville, CA': None,  # Not in our list
        'Thornton, CO': None,  # Not in our list
        'Carrollton, TX': None,  # Not in our list
        'McAllen, TX': None,  # Not in our list
        'Elk Grove, CA': None,  # Not in our list
        'Waco, TX': None,  # Not in our list
        'Bellevue, WA': None,  # Not in our list
        'Peoria, IL': None,  # Not in our list
        'Downey, CA': None,  # Not in our list
        'West Covina, CA': None,  # Not in our list
        'Round Rock, TX': None,  # Not in our list
        'League City, TX': None,  # Not in our list
        'Edinburg, TX': None,  # Not in our list
        'Burbank, CA': None,  # Not in our list
        'Renton, WA': None,  # Not in our list
        'Inglewood, CA': None,  # Not in our list
        'Rialto, CA': None,  # Not in our list
        'Daly City, CA': None,  # Not in our list
        'Lewisville, TX': None,  # Not in our list
        'Tyler, TX': None,  # Not in our list
        'Clovis, CA': None,  # Not in our list
        'San Mateo, CA': None,  # Not in our list
        'Compton, CA': None,  # Not in our list
        'South Bend, IN': None,  # Not in our list
        'Vista, CA': None,  # Not in our list
        'Rochester, MN': None,  # Not in our list
        'Lafayette, LA': None,  # Not in our list
        'Kent, WA': None,  # Not in our list
        'Turlock, CA': None,  # Not in our list
        'Temecula, CA': None,  # Not in our list
        'Antioch, CA': None,  # Not in our list
        'Westminster, CA': None,  # Not in our list
        'Brockton, MA': None,  # Not in our list
        'Richmond, CA': None,  # Not in our list
        'Fairfield, CA': None,  # Not in our list
        'Wichita Falls, TX': None,  # Not in our list
        'High Point, NC': None,  # Not in our list
        'Murrieta, CA': None,  # Not in our list
        'Killeen, TX': None,  # Not in our list
        'Denton, TX': None,  # Not in our list
        'Sunnyvale, CA': None,  # Not in our list
        'Lakewood, CA': None,  # Not in our list
        'Carlsbad, CA': None,  # Not in our list
        'Greeley, CO': None,  # Not in our list
        'Oceanside, CA': None,  # Not in our list
        'Elgin, IL': None,  # Not in our list
        'Norman, OK': None,  # Not in our list
        'Palmdale, CA': None,  # Not in our list
        'Independence, MO': None,  # Not in our list
        'Lakeland, FL': None,  # Not in our list
        'Arvada, CO': None,  # Not in our list
        'Thousand Oaks, CA': None,  # Not in our list
        'Simi Valley, CA': None,  # Not in our list
        'West Jordan, UT': None,  # Not in our list
        'Fargo, ND': 'Fargo',
        'Clearwater, FL': None,  # Not in our list
        'El Monte, CA': None,  # Not in our list
        'Provo, UT': 'Provo',
        'Westminster, CO': None,  # Not in our list
        'Pueblo, CO': None,  # Not in our list
        'Racine, WI': None,  # Not in our list
        'St. George, UT': None,  # Not in our list
        'Norwalk, CA': None,  # Not in our list
        'Santa Monica, CA': None,  # Not in our list
        'Everett, WA': None,  # Not in our list
        'Allentown, PA': None,  # Not in our list
        'Boulder, CO': None,  # Not in our list
        'Kenosha, WI': None,  # Not in our list
        'Bellingham, WA': None,  # Not in our list
        'Green Bay, WI': None,  # Not in our list
        'Duluth, MN': None,  # Not in our list
        'San Angelo, TX': None,  # Not in our list
        'Waterbury, CT': None,  # Not in our list
        'Billings, MT': 'Billings',
        'Largo, FL': None,  # Not in our list
        'Santa Barbara, CA': None,  # Not in our list
        'Pompano Beach, FL': None,  # Not in our list
        'West Palm Beach, FL': None,  # Not in our list
        'Boca Raton, FL': None,  # Not in our list
        'Delray Beach, FL': None,  # Not in our list
        'Boynton Beach, FL': None,  # Not in our list
        'Coral Springs, FL': None,  # Not in our list
        'Port St. Lucie, FL': None,  # Not in our list
        'Fort Pierce, FL': None,  # Not in our list
        'Sebastian, FL': None,  # Not in our list
        'Vero Beach, FL': None,  # Not in our list
        'Palm Beach Gardens, FL': None,  # Not in our list
        'Jupiter, FL': None,  # Not in our list
        'Wellington, FL': None,  # Not in our list
        'Royal Palm Beach, FL': None,  # Not in our list
        'Greenacres, FL': None,  # Not in our list
        'Lake Worth, FL': None,  # Not in our list
        'Riviera Beach, FL': None,  # Not in our list
        'Pahokee, FL': None,  # Not in our list
        'Belle Glade, FL': None,  # Not in our list
        'South Bay, FL': None,  # Not in our list
        'Clewiston, FL': None,  # Not in our list
        'Moore Haven, FL': None,  # Not in our list
        'LaBelle, FL': None,  # Not in our list
        'Immokalee, FL': None,  # Not in our list
        'Naples, FL': None,  # Not in our list
        'Marco Island, FL': None,  # Not in our list
        'Bonita Springs, FL': None,  # Not in our list
        'Estero, FL': None,  # Not in our list
        'Fort Myers, FL': None,  # Not in our list
        'Cape Coral, FL': None,  # Not in our list
        'Sanibel, FL': None,  # Not in our list
        'Captiva, FL': None,  # Not in our list
        'Pine Island, FL': None,  # Not in our list
        'Bokeelia, FL': None,  # Not in our list
        'St. James City, FL': None,  # Not in our list
        'Matlacha, FL': None,  # Not in our list
        'Rotonda West, FL': None,  # Not in our list
        'Placida, FL': None,  # Not in our list
        'Boca Grande, FL': None,  # Not in our list
        'Gasparilla Island, FL': None,  # Not in our list
        'Englewood, FL': None,  # Not in our list
        'Venice, FL': None,  # Not in our list
        'North Port, FL': None,  # Not in our list
        'Port Charlotte, FL': None,  # Not in our list
        'Punta Gorda, FL': None,  # Not in our list
        'Arcadia, FL': None,  # Not in our list
        'Wauchula, FL': None,  # Not in our list
        'Zolfo Springs, FL': None,  # Not in our list
        'Sebring, FL': None,  # Not in our list
        'Avon Park, FL': None,  # Not in our list
        'Lake Placid, FL': None,  # Not in our list
        'Frostproof, FL': None,  # Not in our list
        'Bartow, FL': None,  # Not in our list
        'Winter Haven, FL': None,  # Not in our list
        'Haines City, FL': None,  # Not in our list
        'Davenport, FL': None,  # Not in our list
        'Kissimmee, FL': None,  # Not in our list
        'Celebration, FL': None,  # Not in our list
        'Four Corners, FL': None,  # Not in our list
        'Clermont, FL': None,  # Not in our list
        'Groveland, FL': None,  # Not in our list
        'Mascotte, FL': None,  # Not in our list
        'Minneola, FL': None,  # Not in our list
        'Montverde, FL': None,  # Not in our list
        'Howey-in-the-Hills, FL': None,  # Not in our list
        'Tavares, FL': None,  # Not in our list
        'Mount Dora, FL': None,  # Not in our list
        'Eustis, FL': None,  # Not in our list
        'Umatilla, FL': None,  # Not in our list
        'Paisley, FL': None,  # Not in our list
        'Astatula, FL': None,  # Not in our list
        'Fruitland Park, FL': None,  # Not in our list
        'Lady Lake, FL': None,  # Not in our list
        'The Villages, FL': None,  # Not in our list
        'Oxford, FL': None,  # Not in our list
        'Wildwood, FL': None,  # Not in our list
        'Bushnell, FL': None,  # Not in our list
        'Webster, FL': None,  # Not in our list
        'Center Hill, FL': None,  # Not in our list
        'Mascotte, FL': None,  # Not in our list
        'Okahumpka, FL': None,  # Not in our list
        'Yalaha, FL': None,  # Not in our list
        'Leesburg, FL': None,  # Not in our list
        'Tangerine, FL': None,  # Not in our list
        'Apopka, FL': None,  # Not in our list
        'Ocoee, FL': None,  # Not in our list
        'Windermere, FL': None,  # Not in our list
        'Winter Garden, FL': None,  # Not in our list
        'Gotha, FL': None,  # Not in our list
        'Oakland, FL': None,  # Not in our list
        'Orlando, FL': 'Orlando',
        'Winter Park, FL': None,  # Not in our list
        'Maitland, FL': None,  # Not in our list
        'Eatonville, FL': None,  # Not in our list
        'Oviedo, FL': None,  # Not in our list
        'Casselberry, FL': None,  # Not in our list
        'Altamonte Springs, FL': None,  # Not in our list
        'Longwood, FL': None,  # Not in our list
        'Lake Mary, FL': None,  # Not in our list
        'Heathrow, FL': None,  # Not in our list
        'Sanford, FL': None,  # Not in our list
        'Lake Helen, FL': None,  # Not in our list
        'DeLand, FL': None,  # Not in our list
        'Orange City, FL': None,  # Not in our list
        'DeBary, FL': None,  # Not in our list
        'Deltona, FL': None,  # Not in our list
        'Port Orange, FL': None,  # Not in our list
        'Daytona Beach, FL': None,  # Not in our list
        'South Daytona, FL': None,  # Not in our list
        'Daytona Beach Shores, FL': None,  # Not in our list
        'Ponce Inlet, FL': None,  # Not in our list
        'New Smyrna Beach, FL': None,  # Not in our list
        'Edgewater, FL': None,  # Not in our list
        'Oak Hill, FL': None,  # Not in our list
        'Titusville, FL': None,  # Not in our list
        'Mims, FL': None,  # Not in our list
        'Scottsmoor, FL': None,  # Not in our list
        'Cocoa, FL': None,  # Not in our list
        'Cocoa Beach, FL': None,  # Not in our list
        'Cape Canaveral, FL': None,  # Not in our list
        'Merritt Island, FL': None,  # Not in our list
        'Satellite Beach, FL': None,  # Not in our list
        'Indian Harbour Beach, FL': None,  # Not in our list
        'Indialantic, FL': None,  # Not in our list
        'Melbourne, FL': None,  # Not in our list
        'Melbourne Beach, FL': None,  # Not in our list
        'Palm Bay, FL': None,  # Not in our list
        'West Melbourne, FL': None,  # Not in our list
        'Palm Shores, FL': None,  # Not in our list
        'Grant-Valkaria, FL': None,  # Not in our list
        'Malabar, FL': None,  # Not in our list
        'Sebastian, FL': None,  # Not in our list
        'Fellsmere, FL': None,  # Not in our list
        'Roseland, FL': None,  # Not in our list
        'Wabasso, FL': None,  # Not in our list
        'Vero Beach, FL': None,  # Not in our list
        'Indian River Shores, FL': None,  # Not in our list
        'Orchid, FL': None,  # Not in our list
        'North Beach, FL': None,  # Not in our list
        'South Beach, FL': None,  # Not in our list
        'Gifford, FL': None,  # Not in our list
        'Windsor, FL': None,  # Not in our list
        'Lakewood Park, FL': None,  # Not in our list
        'Fort Pierce, FL': None,  # Not in our list
        'White City, FL': None,  # Not in our list
        'Port St. Lucie, FL': None,  # Not in our list
        'St. Lucie West, FL': None,  # Not in our list
        'Palm City, FL': None,  # Not in our list
        'Jensen Beach, FL': None,  # Not in our list
        'Sewall\'s Point, FL': None,  # Not in our list
        'Stuart, FL': None,  # Not in our list
        'Hobe Sound, FL': None,  # Not in our list
        'Jupiter Island, FL': None,  # Not in our list
        'Jupiter, FL': None,  # Not in our list
        'Juno Beach, FL': None,  # Not in our list
        'Tequesta, FL': None,  # Not in our list
        'Palm Beach Gardens, FL': None,  # Not in our list
        'North Palm Beach, FL': None,  # Not in our list
        'Lake Park, FL': None,  # Not in our list
        'Riviera Beach, FL': None,  # Not in our list
        'Palm Beach, FL': None,  # Not in our list
        'West Palm Beach, FL': None,  # Not in our list
        'South Palm Beach, FL': None,  # Not in our list
        'Lantana, FL': None,  # Not in our list
        'Manalapan, FL': None,  # Not in our list
        'Hypoluxo, FL': None,  # Not in our list
        'Boynton Beach, FL': None,  # Not in our list
        'Gulf Stream, FL': None,  # Not in our list
        'Delray Beach, FL': None,  # Not in our list
        'Highland Beach, FL': None,  # Not in our list
        'Boca Raton, FL': None,  # Not in our list
        'Deerfield Beach, FL': None,  # Not in our list
        'Hillsboro Beach, FL': None,  # Not in our list
        'Lighthouse Point, FL': None,  # Not in our list
        'Pompano Beach, FL': None,  # Not in our list
        'Lauderdale-by-the-Sea, FL': None,  # Not in our list
        'Sea Ranch Lakes, FL': None,  # Not in our list
        'Fort Lauderdale, FL': None,  # Not in our list
        'Wilton Manors, FL': None,  # Not in our list
        'Oakland Park, FL': None,  # Not in our list
        'Lauderdale Lakes, FL': None,  # Not in our list
        'Lauderhill, FL': None,  # Not in our list
        'Plantation, FL': None,  # Not in our list
        'Sunrise, FL': None,  # Not in our list
        'Tamarac, FL': None,  # Not in our list
        'Coral Springs, FL': None,  # Not in our list
        'Parkland, FL': None,  # Not in our list
        'Margate, FL': None,  # Not in our list
        'Coconut Creek, FL': None,  # Not in our list
        'North Lauderdale, FL': None,  # Not in our list
        'Fort Lauderdale, FL': None,  # Not in our list
        'Dania Beach, FL': None,  # Not in our list
        'Hallandale Beach, FL': None,  # Not in our list
        'Hollywood, FL': None,  # Not in our list
        'Pembroke Pines, FL': None,  # Not in our list
        'Miramar, FL': None,  # Not in our list
        'Weston, FL': None,  # Not in our list
        'Davie, FL': None,  # Not in our list
        'Cooper City, FL': None,  # Not in our list
        'Southwest Ranches, FL': None,  # Not in our list
        'Pembroke Park, FL': None,  # Not in our list
        'West Park, FL': None,  # Not in our list
        'Miami Gardens, FL': None,  # Not in our list
        'Opa-locka, FL': None,  # Not in our list
        'Hialeah, FL': None,  # Not in our list
        'Miami Lakes, FL': None,  # Not in our list
        'Medley, FL': None,  # Not in our list
        'Sweetwater, FL': None,  # Not in our list
        'Doral, FL': None,  # Not in our list
        'Virginia Gardens, FL': None,  # Not in our list
        'Miami Springs, FL': None,  # Not in our list
        'Hialeah Gardens, FL': None,  # Not in our list
        'Miami, FL': 'Miami',
        'Key Biscayne, FL': None,  # Not in our list
        'Surfside, FL': None,  # Not in our list
        'Bay Harbor Islands, FL': None,  # Not in our list
        'Bal Harbour, FL': None,  # Not in our list
        'Indian Creek, FL': None,  # Not in our list
        'Golden Beach, FL': None,  # Not in our list
        'Aventura, FL': None,  # Not in our list
        'Sunny Isles Beach, FL': None,  # Not in our list
        'North Bay Village, FL': None,  # Not in our list
        'Miami Beach, FL': None,  # Not in our list
        'Miami Shores, FL': None,  # Not in our list
        'El Portal, FL': None,  # Not in  our list
        'North Miami, FL': None,  # Not in our list
        'North Miami Beach, FL': None,  # Not in our list
        'Miami Gardens, FL': None,  # Not in our list
        'Ojus, FL': None,  # Not in our list
        'Aventura, FL': None,  # Not in our list
        'Sunny Isles Beach, FL': None,  # Not in our list
        'North Bay Village, FL': None,  # Not in our list
        'Miami Beach, FL': None,  # Not in our list
        'Miami Shores, FL': None,  # Not in our list
        'El Portal, FL': None,  # Not in our list
        'North Miami, FL': None,  # Not in our list
        'North Miami Beach, FL': None,  # Not in our list
        'Miami Gardens, FL': None,  # Not in our list
        'Ojus, FL': None,  # Not in our list
        'Aventura, FL': None,  # Not in our list
        'Sunny Isles Beach, FL': None,  # Not in our list
        'North Bay Village, FL': None,  # Not in our list
        'Miami Beach, FL': None,  # Not in our list
        'Miami Shores, FL': None,  # Not in our list
        'El Portal, FL': None,  # Not in our list
        'North Miami, FL': None,  # Not in our list
        'North Miami Beach, FL': None,  # Not in our list
        'Miami Gardens, FL': None,  # Not in our list
        'Ojus, FL': None,  # Not in our list
    }
    
    return mapping

if __name__ == '__main__':
    print("Parsing Zillow CSV...")
    metro_data = parse_zillow_csv()
    print(f"Found {len(metro_data)} metros")
    
    # Create mapping
    city_mapping = create_city_mapping()
    
    # Match metros to our cities
    matched_data = {}
    for zillow_name, city_name in city_mapping.items():
        if city_name and zillow_name in metro_data:
            matched_data[city_name] = metro_data[zillow_name]
            matched_data[city_name]['city_name'] = city_name
    
    # Save to JSON
    output_path = Path(__file__).parent.parent / 'lib' / 'data' / 'sources' / 'zillow_data.json'
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    with open(output_path, 'w') as f:
        json.dump(matched_data, f, indent=2)
    
    print(f"\nMatched {len(matched_data)} cities")
    print(f"Data saved to: {output_path}")
    print("\nSample data:")
    for city, data in list(matched_data.items())[:5]:
        print(f"  {city}: ${data['rent_estimate']:,.0f}/mo (trend: {data['trend']})")

