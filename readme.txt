What's new

· Tax rate autofill:

By clicking "Get location", we will request your Geo Location Permissions while using App, if agree, we will autofill your state sales rate, you don't have to Google or remember your sales rate every time. Due to shortage of funds, we can not afford sales rate API and provide the accurate sales rate for every city, if you feel that the autofill is not accurate, feel free to enter the tax rate manually by clicking the "Not accurate? Enter Tax Manually" button.

How do we implement it?
1. Add the location management delegate protocol： CLLocationManagerDelegate
2. Initialize the location manager object and obtain user permissions
3. Call GeocodeLocation method, create inverse geocoding object CLGeocoder, convert latitude and longitude information to string location information.
4. Get the state rate information in Avalara and match the obtained "admin" information with it.
5. Display the final result


State sales rate source from: https://www.avalara.com/taxrates/en/state-rates.html?gclid=Cj0KCQjwguGYBhDRARIsAHgRm4_i41nwSjp3RSB4nw-fgVw4hjbdCV1WF-30Gvs7fBE5mJQ24nO6MFEaAibaEALw_wcB&CampaignID=7015a000001iyaGAAQ&utm_source=paid_search&utm_medium=gppc&ef_id=Cj0KCQjwguGYBhDRARIsAHgRm4_i41nwSjp3RSB4nw-fgVw4hjbdCV1WF-30Gvs7fBE5mJQ24nO6MFEaAibaEALw_wcB:G:s&s_kwcid=AL!5131!3!338273650925!b!!g!!%2Btax%20%2Brate%20%2Bby%20%2Bcity&gclsrc=aw.ds&&lso=Paid%20Digital&lsmr=Paid%20Digital


· Invalid Input Alert:

Decimal board will be called when you try to input values, also we will detect all user's input and only allow valid input gets through. For example, you can not input letters in both price and discount field, and discount grater that 100% is not allow. In addition, you are not allowed to buy items greater than $100,000(It is very uncommon to buy $100,000 in normal shopping at a time). By implement this function, user's don't need to worry about if they are typing the right thing, we will let them know.

How do we implement it?
1. Used the regular expression: "^[0-9]+([.] [0-9]{1,20})? $" to determine if the correct price, discount and GST are entered correctly
2. Specify that the discount and GST must not be greater than 100% and the price must not be greater than $100,000
3. Only valid input will be displayed in the summary part down below.

