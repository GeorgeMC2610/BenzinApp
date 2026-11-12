///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Logged in as: {username}'
	String loggedInAs({required Object username}) => 'Logged in as: ${username}';

	/// en: 'An error occurred on the server'
	String get serverError => 'An error occurred on the server';

	/// en: 'Bad Connection'
	String get serverErrorTitle => 'Bad Connection';

	/// en: 'There was an error connecting to the server. This might be because the services are down. Please try again in a few minutes.'
	String get serverErrorBody => 'There was an error connecting to the server. This might be because the services are down. Please try again in a few minutes.';

	/// en: 'Wrong credentials'
	String get wrongCredentials => 'Wrong credentials';

	/// en: 'Successfully logged in.'
	String get successfullyLoggedIn => 'Successfully logged in.';

	/// en: 'Your session has ended. Please log in again.'
	String get sessionEnded => 'Your session has ended. Please log in again.';

	/// en: 'Successfully logged out.'
	String get successfullyLoggedOut => 'Successfully logged out.';

	/// en: 'Username is already taken.'
	String get usernameAlreadyTaken => 'Username is already taken.';

	/// en: 'Email is already taken.'
	String get emailAlreadyTaken => 'Email is already taken.';

	/// en: 'Only (latin) letters, numerals, underscores and dashes are allowed'
	String get usernameBad => 'Only (latin) letters, numerals, underscores and dashes are allowed';

	/// en: 'Successfully created account.'
	String get successfullyCreatedAccount => 'Successfully created account.';

	/// en: 'Huh?? 😭'
	String get carsNotExistingBackThen => 'Huh?? 😭';

	/// en: 'Wrong password'
	String get confirmPasswordCorrectly => 'Wrong password';

	/// en: 'Please enable location setting to use this.'
	String get enableLocationSetting => 'Please enable location setting to use this.';

	/// en: 'Permission is denied permanently. Change it in your settings.'
	String get permissionDeniedForever => 'Permission is denied permanently. Change it in your settings.';

	/// en: 'You must grant permission to use this.'
	String get mustGrantPermissionToUseThis => 'You must grant permission to use this.';

	/// en: 'Unable to determine permission status.'
	String get unableToDeterminePermissionStatus => 'Unable to determine permission status.';

	/// en: 'Register to BenzinApp'
	String get registerToBenzinApp => 'Register to BenzinApp';

	/// en: 'Register'
	String get register => 'Register';

	/// en: 'Login to BenzinApp'
	String get loginToBenzinApp => 'Login to BenzinApp';

	/// en: 'Login'
	String get login => 'Login';

	/// en: 'E-Mail'
	String get email => 'E-Mail';

	/// en: 'Enter your e-mail'
	String get emailHint => 'Enter your e-mail';

	/// en: 'Username'
	String get username => 'Username';

	/// en: 'Enter your username'
	String get usernameHint => 'Enter your username';

	/// en: 'E.g. 'one_username_500''
	String get usernameRegisterHint => 'E.g. \'one_username_500\'';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Enter your password'
	String get passwordHint => 'Enter your password';

	/// en: 'Password Confirmation'
	String get passwordConfirmation => 'Password Confirmation';

	/// en: 'Confirm your password'
	String get passwordConfirmationHint => 'Confirm your password';

	/// en: 'Car's Nickname'
	String get carUsername => 'Car\'s Nickname';

	/// en: 'E.g. "my-own-car"'
	String get carUsernameHint => 'E.g. "my-own-car"';

	/// en: 'Car Manufacturer'
	String get carManufacturer => 'Car Manufacturer';

	/// en: 'Enter your car's make name'
	String get carManufacturerHint => 'Enter your car\'s make name';

	/// en: 'Car Model'
	String get carModel => 'Car Model';

	/// en: 'Enter your car's model'
	String get carModelHint => 'Enter your car\'s model';

	/// en: 'Car Year'
	String get carYear => 'Car Year';

	/// en: 'Enter manufacturing year'
	String get carYearHint => 'Enter manufacturing year';

	/// en: 'Currency'
	String get carCurrency => 'Currency';

	/// en: 'E.g. € ή $'
	String get carCurrencyHint => 'E.g. € ή \$';

	/// en: 'You've reached the limit of 7 cars. Chances are that the request to create a new car is going to fail. You must delete and/or transfer the ownership to another user.'
	String get tooManyCars => 'You\'ve reached the limit of 7 cars. Chances are that the request to create a new car is going to fail. You must delete and/or transfer the ownership to another user.';

	/// en: 'Welcome to BenzinApp!'
	String get welcome => 'Welcome to BenzinApp!';

	/// en: 'Welcome Back!'
	String get welcomeBack => 'Welcome Back!';

	/// en: 'Account Details'
	String get accountDetails => 'Account Details';

	/// en: 'A password must be of at least 6 characters of length.'
	String get passwordTooShort => 'A password must be of at least 6 characters of length.';

	/// en: 'Car Details'
	String get carDetails => 'Car Details';

	/// en: 'Create an account'
	String get dontHaveAnAccount => 'Create an account';

	/// en: 'I forgot my password'
	String get forgotPassword => 'I forgot my password';

	/// en: 'I agree to the '
	String get termsPart1 => 'I agree to the ';

	/// en: 'Terms and Conditions'
	String get termsPart2 => 'Terms and Conditions';

	/// en: ' and '
	String get termsPart3 => ' and ';

	/// en: 'Privacy Policy'
	String get termsPart4 => 'Privacy Policy';

	/// en: 'You have locked your account after several failed attempts.'
	String get accountLockedNotification => 'You have locked your account after several failed attempts.';

	/// en: 'Unlock my account'
	String get unlockAccountButton => 'Unlock my account';

	/// en: 'Your account is now unlocked.'
	String get unlockAccountSuccess => 'Your account is now unlocked.';

	/// en: 'Unlock Account'
	String get unlockAccount => 'Unlock Account';

	/// en: 'Too many tries... No result.'
	String get unlockAccountTitle => 'Too many tries... No result.';

	/// en: 'Old BenzinApp User'
	String get welcomeUseCaseAppBar => 'Old BenzinApp User';

	/// en: 'Welcome! Good to have you.'
	String get welcomeUseCase => 'Welcome! Good to have you.';

	/// en: 'You look familiar. Do we know you from somewhere?'
	String get welcomeUseCaseSubtitle => 'You look familiar. Do we know you from somewhere?';

	/// en: 'Yes, I used to be a BenzinApp-BETA user.'
	String get welcomeUseCaseYesButton => 'Yes, I used to be a BenzinApp-BETA user.';

	/// en: 'I didn't use BenzinApp-BETA.'
	String get welcomeUseCaseNoButton => 'I didn\'t use BenzinApp-BETA.';

	/// en: 'Claim an Old Car'
	String get claimCarSettings => 'Claim an Old Car';

	/// en: 'Claim Car'
	String get claimCarAppBar => 'Claim Car';

	/// en: 'Of course we remember!'
	String get claimCarTitle => 'Of course we remember!';

	/// en: 'You have an old car, after all'
	String get claimCarTitleAlt => 'You have an old car, after all';

	/// en: 'How could we possibly forget?'
	String get claimCarSubtitle => 'How could we possibly forget?';

	/// en: 'Interesting! Don't forget about it again, though...'
	String get claimCarSubtitleAlt => 'Interesting! Don\'t forget about it again, though...';

	/// en: 'Please enter your old car's account data:'
	String get enterExistingCarData => 'Please enter your old car\'s account data:';

	/// en: 'Back to Dashboard'
	String get claimCarBackToDashboard => 'Back to Dashboard';

	/// en: 'Claim Car'
	String get claimCarButton => 'Claim Car';

	/// en: 'Successfully claimed old car.'
	String get claimCarSuccess => 'Successfully claimed old car.';

	/// en: 'Dashboard'
	String get dashboardAppBar => 'Dashboard';

	/// en: 'My Cars'
	String get dashboardMyCars => 'My Cars';

	/// en: 'Shared With Me'
	String get dashboardSharedWithMe => 'Shared With Me';

	/// en: 'Add a new car'
	String get addNewCar => 'Add a new car';

	/// en: 'View Details'
	String get viewDetails => 'View Details';

	/// en: 'Your account is not confirmed yet. You have limited features.'
	String get dashboardConfirmAccount => 'Your account is not confirmed yet. You have limited features.';

	/// en: 'Your car was successfully created.'
	String get successfullyCreatedCar => 'Your car was successfully created.';

	/// en: 'Details for {car}'
	String carMenuDetails({required Object car}) => 'Details for ${car}';

	/// en: 'View Details'
	String get carMenuView => 'View Details';

	/// en: 'Edit Car Data'
	String get carMenuEdit => 'Edit Car Data';

	/// en: 'Share with another user'
	String get carMenuShare => 'Share with another user';

	/// en: 'Transfer car ownership'
	String get carMenuTransferOwnership => 'Transfer car ownership';

	/// en: 'Delete'
	String get carMenuDelete => 'Delete';

	/// en: 'Revoke invitation'
	String get carMenuLeaveCar => 'Revoke invitation';

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Fuel Fills'
	String get fuelFills => 'Fuel Fills';

	/// en: 'Maintenance'
	String get maintenance => 'Maintenance';

	/// en: 'Trips'
	String get trips => 'Trips';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Unable to add fuel fill'
	String get fuelFillNotificationTitle => 'Unable to add fuel fill';

	/// en: 'There was a problem uploading the fuel fill. Possibly because the servers are down. Please try again.'
	String get fuelFillNotificationBody => 'There was a problem uploading the fuel fill. Possibly because the servers are down. Please try again.';

	/// en: 'You planned your fuel fill?'
	String get youPlannedYourFuelFill => 'You planned your fuel fill?';

	/// en: 'Last filled today'
	String get lastFilledToday => 'Last filled today';

	/// en: 'Last filled yesterday'
	String get lastFilledYesterday => 'Last filled yesterday';

	/// en: 'Last filled {amountOfDays} days ago'
	String lastFilledDaysAgo({required Object amountOfDays}) => 'Last filled ${amountOfDays} days ago';

	/// en: 'Last filled at {date}'
	String lastFilledAtDate({required Object date}) => 'Last filled at ${date}';

	/// en: 'Insufficient Data!'
	String get insufficientDataTitle => 'Insufficient Data!';

	/// en: 'Normally, here you will see a chart that displays your fuel fill records' data over the course of time. You must have at least three fuel fill records added in order for that to display here. Start adding fuel fill records and see the progress of your car's consumption here!'
	String get insufficientDataText => 'Normally, here you will see a chart that displays your fuel fill records\' data over the course of time. You must have at least three  fuel fill records added in order for that to display here. Start adding fuel fill records and see the progress of your car\'s consumption here!';

	/// en: 'FUEL USAGE TREND'
	String get fuelUsageTrend => 'FUEL USAGE TREND';

	/// en: 'COMBINED COSTS'
	String get combinedCosts => 'COMBINED COSTS';

	/// en: 'AVERAGE CONSUMPTION'
	String get averageConsumption => 'AVERAGE CONSUMPTION';

	/// en: 'TOTAL STATISTICS'
	String get totalStatistics => 'TOTAL STATISTICS';

	/// en: '{volUnit} per 100 {distUnit}:'
	String litersPer100km({required Object volUnit, required Object distUnit}) => '${volUnit} per 100 ${distUnit}:';

	/// en: '{distUnit} per {volUnit}:'
	String kilometersPerLiter({required Object distUnit, required Object volUnit}) => '${distUnit} per ${volUnit}:';

	/// en: 'Cost per {unit}:'
	String costPerKilometer({required Object unit}) => 'Cost per ${unit}:';

	/// en: 'Total Petrol Filled:'
	String get totalLitersFilled => 'Total Petrol Filled:';

	/// en: 'Total Distance Travelled:'
	String get totalKilometersTravelled => 'Total Distance Travelled:';

	/// en: 'Total Costs:'
	String get totalCosts => 'Total Costs:';

	/// en: 'Unable to add service'
	String get serviceNotificationTitle => 'Unable to add service';

	/// en: 'There was a problem uploading the service. Possibly because the servers are down. Please try again.'
	String get serviceNotificationBody => 'There was a problem uploading the service. Possibly because the servers are down. Please try again.';

	/// en: 'Service overdue by {amount} days'
	String serviceOverdueInDays({required Object amount}) => 'Service overdue by ${amount} days';

	/// en: 'Service due today'
	String get serviceDueToday => 'Service due today';

	/// en: 'Service due tomorrow'
	String get serviceDueTomorrow => 'Service due tomorrow';

	/// en: 'Service due in {amount} days'
	String serviceDueInDays({required Object amount}) => 'Service due in ${amount} days';

	/// en: 'Service due in {amount} month(s)'
	String serviceDueInMonths({required Object amount}) => 'Service due in ${amount} month(s)';

	/// en: 'Next service in {date}'
	String serviceDueInDateTime({required Object date}) => 'Next service in ${date}';

	/// en: 'Next service in {amount} {unit}.'
	String nextServiceInKm({required Object amount, required Object unit}) => 'Next service in ${amount} ${unit}.';

	/// en: 'Service overdue by {amount} {unit}'
	String serviceOverdueInKm({required Object amount, required Object unit}) => 'Service overdue by ${amount} ${unit}';

	/// en: 'No Fuel Fill Records.'
	String get noFuelFillRecords => 'No Fuel Fill Records.';

	/// en: 'No Malfunctions.'
	String get noMalfunctions => 'No Malfunctions.';

	/// en: 'No Services.'
	String get noServices => 'No Services.';

	/// en: 'No Trips.'
	String get noTrips => 'No Trips.';

	/// en: 'Repeating Trips'
	String get repeatingTrips => 'Repeating Trips';

	/// en: 'One-Time Trips'
	String get oneTimeTrips => 'One-Time Trips';

	/// en: 'Application Appearance'
	String get applicationAppearance => 'Application Appearance';

	/// en: 'Dark Mode'
	String get darkMode => 'Dark Mode';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Distance Metric'
	String get distanceMetric => 'Distance Metric';

	/// en: 'Volume Metric'
	String get volumeMetric => 'Volume Metric';

	/// en: 'Notification Settings'
	String get notificationSettings => 'Notification Settings';

	/// en: 'Receive extra e-mail notifications'
	String get receiveEmailNotifications => 'Receive extra e-mail notifications';

	/// en: 'Receive in-app push notifications'
	String get receivePushNotifications => 'Receive in-app push notifications';

	/// en: 'Kilometers (km)'
	String get kilometersSetting => 'Kilometers (km)';

	/// en: 'Miles (mi)'
	String get milesSetting => 'Miles (mi)';

	/// en: 'Liters'
	String get litersSetting => 'Liters';

	/// en: 'US Gallons'
	String get gallonsSetting => 'US Gallons';

	/// en: 'Car Options'
	String get carOptions => 'Car Options';

	/// en: 'Account Settings'
	String get accountSettings => 'Account Settings';

	/// en: 'Fast Login'
	String get fastLogin => 'Fast Login';

	/// en: 'Edit Account'
	String get editAccount => 'Edit Account';

	/// en: 'Edit Car Details'
	String get editCarData => 'Edit Car Details';

	/// en: 'Invite a User to this Car'
	String get inviteUserToCar => 'Invite a User to this Car';

	/// en: 'Transfer Car Ownership'
	String get transferOwnership => 'Transfer Car Ownership';

	/// en: 'Delete Car'
	String get deleteCar => 'Delete Car';

	/// en: 'Delete Account'
	String get deleteAccount => 'Delete Account';

	/// en: 'Invitations'
	String get invitations => 'Invitations';

	/// en: 'Logout'
	String get logout => 'Logout';

	/// en: 'About the App'
	String get aboutTheApp => 'About the App';

	/// en: 'Privacy Policy'
	String get privacyPolicy => 'Privacy Policy';

	/// en: 'Terms and Conditions'
	String get termsAndConditions => 'Terms and Conditions';

	/// en: 'App Information'
	String get appInformation => 'App Information';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Malfunctions'
	String get malfunctions => 'Malfunctions';

	/// en: 'Services'
	String get services => 'Services';

	/// en: 'Filters'
	String get filters => 'Filters';

	/// en: 'Search in fuel fills...'
	String get searchInFuelFills => 'Search in fuel fills...';

	/// en: '• {totalRecords} Total Records'
	String totalRecords({required Object totalRecords}) => '• ${totalRecords} Total Records';

	/// en: '• {totalRecords} with current filters'
	String totalFilteredRecords({required Object totalRecords}) => '• ${totalRecords} with current filters';

	/// en: '• Only one record. Singular and lonely...'
	String get oneRecord => '• Only one record. Singular and lonely...';

	/// en: '• One record with current filters'
	String get oneRecordWithFilters => '• One record with current filters';

	/// en: 'Confirm Delete Fuel Fill'
	String get confirmDeleteFuelFill => 'Confirm Delete Fuel Fill';

	/// en: 'Confirm Delete Service'
	String get confirmDeleteService => 'Confirm Delete Service';

	/// en: 'Confirm Delete Malfunction'
	String get confirmDeleteMalfunction => 'Confirm Delete Malfunction';

	/// en: 'Confirm Delete Trip'
	String get confirmDeleteTrips => 'Confirm Delete Trip';

	/// en: 'Are you sure? This action cannot be undone.'
	String get confirmDeleteGenericBody => 'Are you sure? This action cannot be undone.';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Fuel Fill Record Data'
	String get fuelFillRecordData => 'Fuel Fill Record Data';

	/// en: 'Unspecified'
	String get unspecified => 'Unspecified';

	/// en: 'Liters:'
	String get liters => 'Liters:';

	/// en: 'Distance:'
	String get kilometers => 'Distance:';

	/// en: 'Cost:'
	String get cost => 'Cost:';

	/// en: 'Consumption:'
	String get consumption => 'Consumption:';

	/// en: 'Efficiency:'
	String get efficiency => 'Efficiency:';

	/// en: 'Travel Cost:'
	String get travel_cost => 'Travel Cost:';

	/// en: 'Comments:'
	String get comments => 'Comments:';

	/// en: 'Nothing to show here.'
	String get nothingToShowHere => 'Nothing to show here.';

	/// en: 'Edit Fuel Fill Record'
	String get editFuelFillRecord => 'Edit Fuel Fill Record';

	/// en: 'Add Fuel Fill Record'
	String get addFuelFillRecord => 'Add Fuel Fill Record';

	/// en: 'Required Info'
	String get requiredInfo => 'Required Info';

	/// en: 'Small Odometer'
	String get mileage => 'Small Odometer';

	/// en: 'Big Odometer'
	String get totalMileage => 'Big Odometer';

	/// en: 'Odometer'
	String get mileageTitle => 'Odometer';

	/// en: 'Fuel Cost'
	String get costPerVolume => 'Fuel Cost';

	/// en: '{currency}/{unit}'
	String costPerVolumeTitle({required Object currency, required Object unit}) => '${currency}/${unit}';

	/// en: 'Fuel Fill Info'
	String get fuelFillInfo => 'Fuel Fill Info';

	/// en: 'Cost'
	String get cost2 => 'Cost';

	/// en: 'Liters'
	String get liters2 => 'Liters';

	/// en: 'Select a date...'
	String get selectADate => 'Select a date...';

	/// en: 'Pick a date'
	String get pickADate => 'Pick a date';

	/// en: 'Today's date'
	String get todayDate => 'Today\'s date';

	/// en: 'Optional Info'
	String get optionalInfo => 'Optional Info';

	/// en: 'Fuel Type'
	String get fuelType => 'Fuel Type';

	/// en: 'Station Name'
	String get station => 'Station Name';

	/// en: 'Comments'
	String get comments2 => 'Comments';

	/// en: 'Confirm Add'
	String get confirmAdd => 'Confirm Add';

	/// en: 'Confirm Changes'
	String get confirmEdit => 'Confirm Changes';

	/// en: 'in km...'
	String get inKmHint => 'in km...';

	/// en: 'cost'
	String get costHint => 'cost';

	/// en: 'lt'
	String get litersHint => 'lt';

	/// en: 'E.g. "FuelSave 95"'
	String get fuelTypeHint => 'E.g. "FuelSave 95"';

	/// en: 'E.g. "Shell" or "bp"'
	String get stationHint => 'E.g. "Shell" or "bp"';

	/// en: 'Anything useful about this fuel fill...'
	String get commentsHint => 'Anything useful about this fuel fill...';

	/// en: 'You haven't selected a date yet.'
	String get noDateSelected => 'You haven\'t selected a date yet.';

	/// en: 'Cannot be empty'
	String get cannotBeEmpty => 'Cannot be empty';

	/// en: 'Must be positive'
	String get cannotBeNegative => 'Must be positive';

	/// en: 'Must be a positive number'
	String get invalidNumber => 'Must be a positive number';

	/// en: 'Once you enter the next fuel fill, the stats of this one will become available.'
	String get statsCannotBeCalculated => 'Once you enter the next fuel fill, the stats of this one will become available.';

	/// en: 'Successfully added Fuel Fill Record.'
	String get successfullyAddedFuelFill => 'Successfully added Fuel Fill Record.';

	/// en: 'Successfully updated Fuel Fill Record.'
	String get successfullyUpdatedFuelFill => 'Successfully updated Fuel Fill Record.';

	/// en: 'Successfully deleted Fuel Fill Record.'
	String get successfullyDeletedFuelFill => 'Successfully deleted Fuel Fill Record.';

	/// en: 'Small Odometer'
	String get odometerHintTitle1 => 'Small Odometer';

	/// en: 'Small odometer refers to the travelled distance starting from the last time you fuelled your vehicle up until the next time. It's usually written right below your car's speedometer.'
	String get odometerBody1 => 'Small odometer refers to the travelled distance starting from the last time you fuelled your vehicle up until the next time. It\'s usually written right below your car\'s speedometer.';

	/// en: 'Big Odometer'
	String get odometerHintTitle2 => 'Big Odometer';

	/// en: 'Big odometer refers to the total travelled distance of your car. It starts from when the car was bought. If the car is old, this number is usually really big, if the car used. It's usually written right below your car's speedometer'
	String get odometerBody2 => 'Big odometer refers to the total travelled distance of your car. It starts from when the car was bought. If the car is old, this number is usually really big, if the car used. It\'s usually written right below your car\'s speedometer';

	/// en: 'Gas Price per Volume (liter)'
	String get gasPriceTitle => 'Gas Price per Volume (liter)';

	/// en: 'Usually written on big electric boards that display a number with three decimals (x.xxx). This is price per liter and is a big part of calculation for the final price you will pay afterwards. If the price you see on the app is higher than the board, there's a good chance there's been a mistake in your fill-up and you were charged more.'
	String get gasPriceBody => 'Usually written on big electric boards that display a number with three decimals (x.xxx). This is price per liter and is a big part of calculation for the final price you will pay afterwards. If the price you see on the app is higher than the board, there\'s a good chance there\'s been a mistake in your fill-up and you were charged more.';

	/// en: 'Liters'
	String get ffrStatsTitle1 => 'Liters';

	/// en: 'The total liters you filled in your car will be listed on the receipt and/or the pump. If you don't remember how many liters you filled, you can enter the cost per liter and the total cost. Then, the app will automatically calculate how many liters you put in the car.'
	String get ffrStatsBody1 => 'The total liters you filled in your car will be listed on the receipt and/or the pump. If you don\'t remember how many liters you filled, you can enter the cost per liter and the total cost. Then, the app will automatically calculate how many liters you put in the car.';

	/// en: 'Cost'
	String get ffrStatsTitle2 => 'Cost';

	/// en: 'The final price you paid should be listed in the same place where the total liters are shown. You can also find this on your receipt.'
	String get ffrStatsBody2 => 'The final price you paid should be listed in the same place where the total liters are shown. You can also find this on your receipt.';

	/// en: 'Discovered at:'
	String get discoveredAt => 'Discovered at:';

	/// en: 'Ongoing'
	String get ongoingMalfunction => 'Ongoing';

	/// en: 'Fixed'
	String get fixedMalfunction => 'Fixed';

	/// en: 'Next:'
	String get nextAtKm => 'Next:';

	/// en: 'at'
	String get at => 'at';

	/// en: 'or before'
	String get orBefore => 'or before';

	/// en: 'before'
	String get before => 'before';

	/// en: 'Unable to add malfunction'
	String get malfunctionNotificationTitle => 'Unable to add malfunction';

	/// en: 'There was a problem uploading the malfunction. Possibly because the servers are down. Please try again.'
	String get malfunctionNotificationBody => 'There was a problem uploading the malfunction. Possibly because the servers are down. Please try again.';

	/// en: 'Malfunction data'
	String get malfunctionData => 'Malfunction data';

	/// en: 'Date discovered:'
	String get dateDiscovered => 'Date discovered:';

	/// en: 'Kilometers discovered:'
	String get kilometersDiscovered => 'Kilometers discovered:';

	/// en: 'Status:'
	String get status => 'Status:';

	/// en: 'Title:'
	String get title => 'Title:';

	/// en: 'Description:'
	String get description => 'Description:';

	/// en: 'Date fixed:'
	String get dateFixed => 'Date fixed:';

	/// en: 'Location:'
	String get locationFixed => 'Location:';

	/// en: 'Successfully added Malfunction.'
	String get successfullyAddedMalfunction => 'Successfully added Malfunction.';

	/// en: 'Successfully updated Malfunction.'
	String get successfullyUpdatedMalfunction => 'Successfully updated Malfunction.';

	/// en: 'Successfully deleted Malfunction.'
	String get successfullyDeletedMalfunction => 'Successfully deleted Malfunction.';

	/// en: 'Service Data'
	String get serviceData => 'Service Data';

	/// en: 'Last Service'
	String get lastService => 'Last Service';

	/// en: 'Previous Services'
	String get previousServices => 'Previous Services';

	/// en: 'Date done:'
	String get dateDone => 'Date done:';

	/// en: 'Service distance:'
	String get serviceMileage => 'Service distance:';

	/// en: 'Next service at:'
	String get nextServiceAt => 'Next service at:';

	/// en: 'Next service date...'
	String get selectNextServiceDate => 'Next service date...';

	/// en: 'Location:'
	String get location => 'Location:';

	/// en: 'See on map'
	String get seeOnMap => 'See on map';

	/// en: 'Maintenance Category'
	String get maintenanceCategory => 'Maintenance Category';

	/// en: 'Select maintenance type:'
	String get selectMaintenanceType => 'Select maintenance type:';

	/// en: 'Malfunction'
	String get malfunction => 'Malfunction';

	/// en: 'Service'
	String get service => 'Service';

	/// en: 'Coming Soon...'
	String get comingSoon => 'Coming Soon...';

	/// en: 'Add Service'
	String get addService => 'Add Service';

	/// en: 'Edit Service'
	String get editService => 'Edit Service';

	/// en: 'Service Info'
	String get serviceInfo => 'Service Info';

	/// en: 'Description'
	String get description2 => 'Description';

	/// en: 'Service Distance'
	String get serviceMileage2 => 'Service Distance';

	/// en: 'Next Service Mileage'
	String get nextServiceMileage => 'Next Service Mileage';

	/// en: 'What happened in this service?'
	String get descriptionHint => 'What happened in this service?';

	/// en: 'Enter service mileage...'
	String get serviceMileageHint => 'Enter service mileage...';

	/// en: 'Next Service Info'
	String get nextServiceInfo => 'Next Service Info';

	/// en: 'Enter next service mileage...'
	String get nextServiceMileageHint => 'Enter next service mileage...';

	/// en: 'Confirm Add Service'
	String get confirmAddService => 'Confirm Add Service';

	/// en: 'Successfully added Service.'
	String get successfullyAddedService => 'Successfully added Service.';

	/// en: 'Successfully updated Service.'
	String get successfullyUpdatedService => 'Successfully updated Service.';

	/// en: 'Successfully deleted Service.'
	String get successfullyDeletedService => 'Successfully deleted Service.';

	/// en: 'Add Malfunction'
	String get addMalfunction => 'Add Malfunction';

	/// en: 'Edit Malfunction'
	String get editMalfunction => 'Edit Malfunction';

	/// en: 'Malfunction Info'
	String get malfunctionInfo => 'Malfunction Info';

	/// en: 'Title'
	String get malfunctionTitle => 'Title';

	/// en: 'Malfunction Severity'
	String get malfunctionSeverity => 'Malfunction Severity';

	/// en: 'Lowest'
	String get severityLowest => 'Lowest';

	/// en: 'Low'
	String get severityLow => 'Low';

	/// en: 'Normal'
	String get severityNormal => 'Normal';

	/// en: 'High'
	String get severityHigh => 'High';

	/// en: 'Highest'
	String get severityHighest => 'Highest';

	/// en: 'Select end date...'
	String get malfunctionEnded => 'Select end date...';

	/// en: 'What's malfunctioning...?'
	String get malfunctionTitleHint => 'What\'s malfunctioning...?';

	/// en: 'Describe what is malfunctioning...'
	String get descriptionHintMalfunction => 'Describe what is malfunctioning...';

	/// en: 'Please select an end date.'
	String get pleaseSelectAnEndDate => 'Please select an end date.';

	/// en: 'I fixed this malfunction'
	String get iFixedThisMalfunction => 'I fixed this malfunction';

	/// en: 'Repair Data'
	String get repairData => 'Repair Data';

	/// en: 'Repair Cost'
	String get repairCost => 'Repair Cost';

	/// en: 'Enter cost...'
	String get repairCostHint => 'Enter cost...';

	/// en: 'Warning! By unchecking the box, you will mark this functions as ongoing.'
	String get uncheckingTheBox => 'Warning! By unchecking the box, you will mark this functions as ongoing.';

	/// en: 'Select location...'
	String get selectLocation => 'Select location...';

	/// en: 'Trips rely on your data!'
	String get pleaseEnterFuelFills => 'Trips rely on your data!';

	/// en: 'Please enter at least 3 fuel fills to see the cost and consumption of your trips.'
	String get atlEastThreeFuelFills => 'Please enter at least 3 fuel fills to see the cost and consumption of your trips.';

	/// en: 'Unable to add trip'
	String get tripNotificationTitle => 'Unable to add trip';

	/// en: 'There was a problem uploading the trip. Possibly because the servers are down. Please try again.'
	String get tripNotificationBody => 'There was a problem uploading the trip. Possibly because the servers are down. Please try again.';

	/// en: 'Trip Data'
	String get tripData => 'Trip Data';

	/// en: 'Title:'
	String get tripName => 'Title:';

	/// en: 'Weekly Occurrence:'
	String get weeklyOccurrence => 'Weekly Occurrence:';

	/// en: 'Trip Distance:'
	String get tripDistance => 'Trip Distance:';

	/// en: 'Analytics Per Time'
	String get analyticsPerTime => 'Analytics Per Time';

	/// en: 'per time'
	String get perTime => 'per time';

	/// en: 'Weekly Analytics'
	String get weeklyAnalytics => 'Weekly Analytics';

	/// en: 'per week'
	String get perWeek => 'per week';

	/// en: 'Map Details'
	String get mapDetails => 'Map Details';

	/// en: 'Show on maps'
	String get showOnMaps => 'Show on maps';

	/// en: 'Repeating {n} times per week'
	String repeatingTimesPerWeek({required Object n}) => 'Repeating ${n} times per week';

	/// en: '{n} times per week'
	String repeatingTimesPerWeekShort({required Object n}) => '${n} times per week';

	/// en: 'Doesn't Repeat'
	String get noRepeat => 'Doesn\'t Repeat';

	/// en: 'Created at: {date}'
	String createdAt({required Object date}) => 'Created at: ${date}';

	/// en: 'Best case'
	String get bestCase => 'Best case';

	/// en: 'Average case'
	String get averageCase => 'Average case';

	/// en: 'Worst case'
	String get worstCase => 'Worst case';

	/// en: 'One-time trip'
	String get oneTimeTrip => 'One-time trip';

	/// en: 'View Location On Maps'
	String get viewLocation => 'View Location On Maps';

	/// en: 'View Tip On Maps'
	String get viewTrip => 'View Tip On Maps';

	/// en: 'Origin'
	String get origin => 'Origin';

	/// en: 'Destination'
	String get destination => 'Destination';

	/// en: 'Add Trip'
	String get addTrip => 'Add Trip';

	/// en: 'Edit Trip'
	String get editTrip => 'Edit Trip';

	/// en: 'Trip Info'
	String get tripInfo => 'Trip Info';

	/// en: 'Trip's Title'
	String get tripName2 => 'Trip\'s Title';

	/// en: 'E.g.: "Trip to Florida" or "Home to Work"...'
	String get tripNameHint => 'E.g.: "Trip to Florida" or "Home to Work"...';

	/// en: 'Occurrence'
	String get timesRepeating => 'Occurrence';

	/// en: 'Per Week'
	String get timesRepeatingHint => 'Per Week';

	/// en: 'Make Trip...'
	String get makeTrip => 'Make Trip...';

	/// en: 'Make on Maps'
	String get makeOnMaps => 'Make on Maps';

	/// en: 'Pick on Maps'
	String get pickAPlace => 'Pick on Maps';

	/// en: 'Remove location'
	String get removeLocation => 'Remove location';

	/// en: 'Delete Trip'
	String get deleteTrip => 'Delete Trip';

	/// en: 'Create Trip on Maps'
	String get createTrip => 'Create Trip on Maps';

	/// en: 'Pick Location on Maps'
	String get pickLocationOnMap => 'Pick Location on Maps';

	/// en: 'Type an address, or long-press on the map.'
	String get typeAnAddress => 'Type an address, or long-press on the map.';

	/// en: 'Search Address'
	String get searchAddress => 'Search Address';

	/// en: 'Type an address for the origin...'
	String get searchAddressHintOrigin => 'Type an address for the origin...';

	/// en: 'Type an address for the destination...'
	String get searchAddressHintDestination => 'Type an address for the destination...';

	/// en: 'Type an address for the location...'
	String get searchAddressHintLocation => 'Type an address for the location...';

	/// en: 'Successfully added Trip.'
	String get successfullyAddedTrip => 'Successfully added Trip.';

	/// en: 'Successfully updated Trip.'
	String get successfullyUpdatedTrip => 'Successfully updated Trip.';

	/// en: 'Successfully deleted Trip.'
	String get successfullyDeletedTrip => 'Successfully deleted Trip.';

	/// en: 'FROM'
	String get from => 'FROM';

	/// en: 'TO'
	String get to => 'TO';

	/// en: 'Please make a trip.'
	String get pleaseMakeATrip => 'Please make a trip.';

	/// en: 'No places found with this address.'
	String get noPlacesFoundWithThisAddress => 'No places found with this address.';

	/// en: 'There is no route available for the current positions.'
	String get noTripsFound => 'There is no route available for the current positions.';

	/// en: 'Confirm Trip'
	String get confirmTrip => 'Confirm Trip';

	/// en: 'Use my location'
	String get useMyLocation => 'Use my location';

	/// en: 'Swap origin and destination'
	String get swapOriginDestination => 'Swap origin and destination';

	/// en: 'Tip: long-press the map to set the origin.'
	String get longPressToSetOrigin => 'Tip: long-press the map to set the origin.';

	/// en: 'Tip: long-press the map to set the destination.'
	String get longPressToSetDestination => 'Tip: long-press the map to set the destination.';

	/// en: 'via {road}'
	String viaRoad({required Object road}) => 'via ${road}';

	/// en: 'Couldn't get your location. Check that location is turned on and allowed for BenzinApp.'
	String get locationUnavailable => 'Couldn\'t get your location. Check that location is turned on and allowed for BenzinApp.';

	/// en: 'Couldn't load routes. Check your connection and try again.'
	String get routeRequestFailed => 'Couldn\'t load routes. Check your connection and try again.';

	/// en: 'Confirm Location'
	String get confirmLocation => 'Confirm Location';

	/// en: 'Fuel Fill Filters'
	String get fuelFilters => 'Fuel Fill Filters';

	/// en: 'Malfunction Filters'
	String get malfunctionFilters => 'Malfunction Filters';

	/// en: 'Service Filters'
	String get serviceFilters => 'Service Filters';

	/// en: 'Status'
	String get statusFilter => 'Status';

	/// en: 'Severity'
	String get severityFilter => 'Severity';

	/// en: 'All Statuses'
	String get allStatuses => 'All Statuses';

	/// en: 'Only Fixed'
	String get onlyFixed => 'Only Fixed';

	/// en: 'Only Ongoing'
	String get onlyUnfixed => 'Only Ongoing';

	/// en: 'Group By'
	String get groupBy => 'Group By';

	/// en: 'None'
	String get groupNone => 'None';

	/// en: 'Status'
	String get groupStatus => 'Status';

	/// en: 'Severity'
	String get groupSeverity => 'Severity';

	/// en: 'Search in malfunctions...'
	String get searchInMalfunctions => 'Search in malfunctions...';

	/// en: 'Search in services...'
	String get searchInServices => 'Search in services...';

	/// en: 'All Severities'
	String get allSeverities => 'All Severities';

	/// en: 'Station, fuel type or ID'
	String get searchHint => 'Station, fuel type or ID';

	/// en: 'From:'
	String get fromDate => 'From:';

	/// en: 'To:'
	String get toDate => 'To:';

	/// en: '<not selected>'
	String get notSelected => '<not selected>';

	/// en: 'From {unit}'
	String startKm({required Object unit}) => 'From ${unit}';

	/// en: 'To {unit}'
	String endKm({required Object unit}) => 'To ${unit}';

	/// en: 'From {unit}'
	String startLt({required Object unit}) => 'From ${unit}';

	/// en: 'To {unit}'
	String endLt({required Object unit}) => 'To ${unit}';

	/// en: 'From total {unit}'
	String startTotalKm({required Object unit}) => 'From total ${unit}';

	/// en: 'To total {unit}'
	String endTotalKm({required Object unit}) => 'To total ${unit}';

	/// en: 'From cost'
	String get startCost => 'From cost';

	/// en: 'To cost'
	String get endCost => 'To cost';

	/// en: 'Discard'
	String get discard => 'Discard';

	/// en: 'Apply'
	String get apply => 'Apply';

	/// en: 'Edit Car'
	String get editCar => 'Edit Car';

	/// en: 'Add Car'
	String get addCar => 'Add Car';

	/// en: 'Successfully updated Car info.'
	String get successfullyUpdatedCar => 'Successfully updated Car info.';

	/// en: 'Check your E-Mail. You should find a code.'
	String get checkYourEmail => 'Check your E-Mail. You should find a code.';

	/// en: 'Once you find it, enter it here:'
	String get enterCode => 'Once you find it, enter it here:';

	/// en: 'Resend'
	String get resendButton => 'Resend';

	/// en: 'Wrong or expired code'
	String get wrongCode => 'Wrong or expired code';

	/// en: 'Please enter the code'
	String get emptyCode => 'Please enter the code';

	/// en: 'Confirm Account'
	String get confirmAccount => 'Confirm Account';

	/// en: 'Confirm'
	String get confirmButton => 'Confirm';

	/// en: 'Let's verify your account'
	String get confirmAccountTitle => 'Let\'s verify your account';

	/// en: 'Skip verification for now.'
	String get skipVerification => 'Skip verification for now.';

	/// en: 'Please wait at least two (2) minutes.'
	String get confirmAccountPleaseWait => 'Please wait at least two (2) minutes.';

	/// en: 'You were already confirmed. Sorry!'
	String get confirmAccountAlreadyConfirmed => 'You were already confirmed. Sorry!';

	/// en: 'Something else went wrong. Please, try again later.'
	String get confirmAccountSomethingElseWentWrong => 'Something else went wrong. Please, try again later.';

	/// en: 'What happens if I skip?'
	String get skipConsequences => 'What happens if I skip?';

	/// en: 'What happens if you skip?'
	String get skipConsequencesTitle1 => 'What happens if you skip?';

	/// en: 'Without confirming your account, your experience is limited. You can only have one car and one fuel fill, you can't use sharing or advanced features, and old BenzinApp users can't retrieve their previous cars.'
	String get skipConsequencesText1 => 'Without confirming your account, your experience is limited. You can only have one car and one fuel fill, you can\'t use sharing or advanced features, and old BenzinApp users can\'t retrieve their previous cars.';

	/// en: 'You can confirm your account anytime from Settings --> User Settings --> Confirm Account. Unconfirmed users are reminded at every login.'
	String get skipConsequencesText2 => 'You can confirm your account anytime from Settings --> User Settings --> Confirm Account. Unconfirmed users are reminded at every login.';

	/// en: 'Successfully confirmed your account'
	String get confirmAccountOkay => 'Successfully confirmed your account';

	/// en: 'Forgot Password'
	String get forgotPasswordMenu => 'Forgot Password';

	/// en: 'Reset Password'
	String get resetPasswordMenu => 'Reset Password';

	/// en: 'Forgot your password?'
	String get forgotPasswordTitle => 'Forgot your password?';

	/// en: 'Tough one. But, it happens to the best of us.'
	String get forgotPasswordSubtitle => 'Tough one. But, it happens to the best of us.';

	/// en: 'Please provide the e-mail associated with your account.'
	String get forgotPasswordEmailPrompt => 'Please provide the e-mail associated with your account.';

	/// en: 'E-Mail'
	String get forgotPasswordEmailLabel => 'E-Mail';

	/// en: 'Your account's email address...'
	String get forgotPasswordEmailHint => 'Your account\'s email address...';

	/// en: 'Next Step'
	String get forgotPasswordNextStep => 'Next Step';

	/// en: 'You're almost there!'
	String get forgotPasswordSecondStepTitle => 'You\'re almost there!';

	/// en: 'Then, enter a new password'
	String get forgotPasswordSecondStepEnterPassword => 'Then, enter a new password';

	/// en: 'New password'
	String get forgotPasswordSecondStepPasswordLabel => 'New password';

	/// en: 'Enter your new password...'
	String get forgotPasswordSecondStepPasswordHint => 'Enter your new password...';

	/// en: 'Confirm Password'
	String get forgotPasswordSecondStepPasswordConfirmLabel => 'Confirm Password';

	/// en: 'Confirm your new password...'
	String get forgotPasswordSecondStepPasswordConfirmHint => 'Confirm your new password...';

	/// en: 'Something else went wrong. Error code: {code}'
	String forgotPasswordErrorSomethingElse({required Object code}) => 'Something else went wrong. Error code: ${code}';

	/// en: 'Successfully reset password'
	String get forgotPasswordSuccessfullyReset => 'Successfully reset password';

	/// en: 'Requested a new code too early'
	String get forgotPasswordErrorTooEarly => 'Requested a new code too early';

	/// en: 'Finish'
	String get forgotPasswordFinishButton => 'Finish';

	/// en: 'Invitations'
	String get general_invitations => 'Invitations';

	/// en: 'Incoming'
	String get incoming => 'Incoming';

	/// en: 'Outgoing'
	String get outgoing => 'Outgoing';

	/// en: 'Pending'
	String get pending => 'Pending';

	/// en: 'Accepted'
	String get accepted => 'Accepted';

	/// en: 'Accepted Invitations'
	String get accepted_invitations => 'Accepted Invitations';

	/// en: 'Pending Invitations'
	String get pending_invitations => 'Pending Invitations';

	/// en: 'Revoke'
	String get revoke => 'Revoke';

	/// en: 'Leave'
	String get leave => 'Leave';

	/// en: 'No invitations'
	String get noInvitations => 'No invitations';

	/// en: 'Sent at: {date}'
	String sentAt({required Object date}) => 'Sent at: ${date}';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Invitation Accepted.'
	String get invitationAccepted => 'Invitation Accepted.';

	/// en: 'Invitation Revoked.'
	String get invitationCanceled => 'Invitation Revoked.';

	/// en: 'Reject Invitation'
	String get rejectInvitation => 'Reject Invitation';

	/// en: 'Invoke Invitation'
	String get revokeInvitation => 'Invoke Invitation';

	/// en: 'Cancel Invitation'
	String get cancelInvitation => 'Cancel Invitation';

	/// en: 'Are you sure you want to leave from the car {car}?'
	String areYouSureYouWantToLeaveThisCar({required Object car}) => 'Are you sure you want to leave from the car ${car}?';

	/// en: 'Are you sure you want to reject this invitation?'
	String get areYouSureYouWantToRejectThisInvitation => 'Are you sure you want to reject this invitation?';

	/// en: 'Are you sure you want to revoke access from {user} regarding the car {car}; (This user will no longer be able to see or edit the car's data)'
	String areYouSureYouWantToRevokeAccess({required Object user, required Object car}) => 'Are you sure you want to revoke access from ${user} regarding the car ${car}; (This user will no longer be able to see or edit the car\'s data)';

	/// en: '{user} has yet to accept the invitation for the car {car}. Are you sure you want to invoke this invitation?'
	String areYouSureYouWantToCancelInvitationForThisUser({required Object user, required Object car}) => '${user} has yet to accept the invitation for the car ${car}. Are you sure you want to invoke this invitation?';

	/// en: 'Invite User to Car'
	String get inviteUserToCarAppBar => 'Invite User to Car';

	/// en: 'Share car details with friends'
	String get inviteUserToCarTitle => 'Share car details with friends';

	/// en: 'They'll love to see your statistics! No?'
	String get inviteUserToCarSubtitle => 'They\'ll love to see your statistics! No?';

	/// en: 'Enter the associated username:'
	String get enterUsernameToInvite => 'Enter the associated username:';

	/// en: 'Username'
	String get sharedUsername => 'Username';

	/// en: 'Enter your friend's username...'
	String get sharedUsernameHint => 'Enter your friend\'s username...';

	/// en: 'Send Invitation'
	String get sendInvitationButton => 'Send Invitation';

	/// en: 'Invitation sent to {user}.'
	String invitationSent({required Object user}) => 'Invitation sent to ${user}.';

	/// en: 'Invitation rejected.'
	String get invitationRejected => 'Invitation rejected.';

	/// en: 'Select access level:'
	String get selectAccessLevel => 'Select access level:';

	/// en: 'Moderator'
	String get accessModerator => 'Moderator';

	/// en: 'Viewer'
	String get accessViewer => 'Viewer';

	/// en: 'Contributor'
	String get accessContributor => 'Contributor';

	/// en: 'Access Level'
	String get accessLevel => 'Access Level';

	/// en: 'Viewers can see the data but not modify them.'
	String get accessViewerDesc => 'Viewers can see the data but not modify them.';

	/// en: 'Contributors can see the data, add/update/delete them.'
	String get accessContributorDesc => 'Contributors can see the data, add/update/delete them.';

	/// en: 'Moderators can see the data, add/update/delete them, and also invite other users to this car.'
	String get accessModeratorDesc => 'Moderators can see the data, add/update/delete them, and also invite other users to this car.';

	/// en: 'Delete Car'
	String get deleteCarAppBar => 'Delete Car';

	/// en: 'Delete the car {carName}'
	String deleteCarTitle({required Object carName}) => 'Delete the car ${carName}';

	/// en: '...and all of its data'
	String get deleteCarSubtitle => '...and all of its data';

	/// en: 'To confirm, please type "{carName}":'
	String deleteCarEnterCarNameToDelete({required Object carName}) => 'To confirm, please type "${carName}":';

	/// en: 'Retype car name'
	String get deleteCarEnterCarName => 'Retype car name';

	/// en: 'Be careful! If you confirm the deletion, there's no way of redoing it. All of the car's fuel fill records, malfunctions, services, etc. will be permanently deleted.'
	String get deleteCarWarning => 'Be careful! If you confirm the deletion, there\'s no way of redoing it. All of the car\'s fuel fill records, malfunctions, services, etc. will be permanently deleted.';

	/// en: 'Delete Car'
	String get deleteCarButton => 'Delete Car';

	/// en: 'Successfully deleted car'
	String get carDeletedSuccessfully => 'Successfully deleted car';

	/// en: 'Failed to delete car'
	String get carDeletionFailed => 'Failed to delete car';

	/// en: 'Delete Account'
	String get deleteAccountAppBar => 'Delete Account';

	/// en: 'We will miss you...'
	String get deleteAccountTitle => 'We will miss you...';

	/// en: 'he hope to see you again!'
	String get deleteAccountSubtitle => 'he hope to see you again!';

	/// en: 'Be careful! Once you approve this, there's no going back! All your data -fuel fills, malfunctions, etc-, will be gone forever with no way of restoring it! Please be certain before approving this action.'
	String get deleteAccountWarning => 'Be careful! Once you approve this, there\'s no going back! All your data -fuel fills, malfunctions, etc-, will be gone forever with no way of restoring it! Please be certain before approving this action.';

	/// en: 'Danger Zone'
	String get deleteAccountDangerZone => 'Danger Zone';

	/// en: 'To confirm the deletion, please type "{username}":'
	String deleteAccountRetypeUsernameTitle({required Object username}) => 'To confirm the deletion, please type "${username}":';

	/// en: 'Re-type your username'
	String get deleteAccountRetypeUsername => 'Re-type your username';

	/// en: 'To confirm the deletion, please re-type your current password'
	String get deleteAccountRetypePasswordTitle => 'To confirm the deletion, please re-type your current password';

	/// en: 'Re-type your password'
	String get deleteAccountRetypePassword => 'Re-type your password';

	/// en: 'Delete Account'
	String get deleteAccountButton => 'Delete Account';

	/// en: 'Could not delete account'
	String get accountDeletionFailed => 'Could not delete account';

	/// en: 'Account deleted successfully'
	String get accountDeletedSuccessfully => 'Account deleted successfully';

	/// en: 'Transfer Car Ownership'
	String get transferCarOwnershipAppBar => 'Transfer Car Ownership';

	/// en: 'Transfer the ownership'
	String get transferCarOwnershipTitle => 'Transfer the ownership';

	/// en: 'You'll no longer be the owner of this car'
	String get transferCarOwnershipSubtitle => 'You\'ll no longer be the owner of this car';

	/// en: 'Be careful! If you confirm the ownership transfer, there's no way of redoing it. You'll be asked to confirm multiple times, once you select a user.'
	String get transferCarOwnershipWarning => 'Be careful! If you confirm the ownership transfer, there\'s no way of redoing it. You\'ll be asked to confirm multiple times, once you select a user.';

	/// en: 'Select a user'
	String get transferCarOwnershipSelectUser => 'Select a user';

	/// en: 'Please select the user you want to transfer the car to:'
	String get transferCarOwnershipSelectUserTitle => 'Please select the user you want to transfer the car to:';

	/// en: 'You're entering the danger zone!'
	String get transferCarOwnershipDangerZone => 'You\'re entering the danger zone!';

	/// en: 'Retype the username'
	String get transferCarOwnershipRetypeUsername => 'Retype the username';

	/// en: 'To confirm the transfer, please type "{username}":'
	String transferCarOwnershipRetypeUsernameTitle({required Object username}) => 'To confirm the transfer, please type "${username}":';

	/// en: 'Retype the car's name'
	String get transferCarOwnershipRetypeCarName => 'Retype the car\'s name';

	/// en: 'Confirm the transfer again and type "{carName}":'
	String transferCarOwnershipRetypeCarNameTitle({required Object carName}) => 'Confirm the transfer again and type "${carName}":';

	/// en: 'Transfer Ownership'
	String get transferCarOwnershipButton => 'Transfer Ownership';

	/// en: 'Successfully transferred car's ownership'
	String get carTransferredSuccessfully => 'Successfully transferred car\'s ownership';

	/// en: 'Failed to transfer car's ownership'
	String get carTransferFailed => 'Failed to transfer car\'s ownership';

	/// en: 'Last 1 month'
	String get lastMonth => 'Last 1 month';

	/// en: 'Last 2 months'
	String get lastTwoMonths => 'Last 2 months';

	/// en: 'Last 3 months'
	String get lastThreeMonths => 'Last 3 months';

	/// en: 'Last 4 months'
	String get lastFourMonths => 'Last 4 months';

	/// en: 'Last 6 months'
	String get lastSixMonths => 'Last 6 months';

	/// en: 'Last 10 months'
	String get lastTenMonths => 'Last 10 months';

	/// en: 'Last 12 months'
	String get lastTwelveMonths => 'Last 12 months';

	/// en: 'Lifetime'
	String get lifetime => 'Lifetime';

	/// en: 'Custom Range'
	String get customRange => 'Custom Range';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'loggedInAs' => ({required Object username}) => 'Logged in as: ${username}',
			'serverError' => 'An error occurred on the server',
			'serverErrorTitle' => 'Bad Connection',
			'serverErrorBody' => 'There was an error connecting to the server. This might be because the services are down. Please try again in a few minutes.',
			'wrongCredentials' => 'Wrong credentials',
			'successfullyLoggedIn' => 'Successfully logged in.',
			'sessionEnded' => 'Your session has ended. Please log in again.',
			'successfullyLoggedOut' => 'Successfully logged out.',
			'usernameAlreadyTaken' => 'Username is already taken.',
			'emailAlreadyTaken' => 'Email is already taken.',
			'usernameBad' => 'Only (latin) letters, numerals, underscores and dashes are allowed',
			'successfullyCreatedAccount' => 'Successfully created account.',
			'carsNotExistingBackThen' => 'Huh?? 😭',
			'confirmPasswordCorrectly' => 'Wrong password',
			'enableLocationSetting' => 'Please enable location setting to use this.',
			'permissionDeniedForever' => 'Permission is denied permanently. Change it in your settings.',
			'mustGrantPermissionToUseThis' => 'You must grant permission to use this.',
			'unableToDeterminePermissionStatus' => 'Unable to determine permission status.',
			'registerToBenzinApp' => 'Register to BenzinApp',
			'register' => 'Register',
			'loginToBenzinApp' => 'Login to BenzinApp',
			'login' => 'Login',
			'email' => 'E-Mail',
			'emailHint' => 'Enter your e-mail',
			'username' => 'Username',
			'usernameHint' => 'Enter your username',
			'usernameRegisterHint' => 'E.g. \'one_username_500\'',
			'password' => 'Password',
			'passwordHint' => 'Enter your password',
			'passwordConfirmation' => 'Password Confirmation',
			'passwordConfirmationHint' => 'Confirm your password',
			'carUsername' => 'Car\'s Nickname',
			'carUsernameHint' => 'E.g. "my-own-car"',
			'carManufacturer' => 'Car Manufacturer',
			'carManufacturerHint' => 'Enter your car\'s make name',
			'carModel' => 'Car Model',
			'carModelHint' => 'Enter your car\'s model',
			'carYear' => 'Car Year',
			'carYearHint' => 'Enter manufacturing year',
			'carCurrency' => 'Currency',
			'carCurrencyHint' => 'E.g. € ή \$',
			'tooManyCars' => 'You\'ve reached the limit of 7 cars. Chances are that the request to create a new car is going to fail. You must delete and/or transfer the ownership to another user.',
			'welcome' => 'Welcome to BenzinApp!',
			'welcomeBack' => 'Welcome Back!',
			'accountDetails' => 'Account Details',
			'passwordTooShort' => 'A password must be of at least 6 characters of length.',
			'carDetails' => 'Car Details',
			'dontHaveAnAccount' => 'Create an account',
			'forgotPassword' => 'I forgot my password',
			'termsPart1' => 'I agree to the ',
			'termsPart2' => 'Terms and Conditions',
			'termsPart3' => ' and ',
			'termsPart4' => 'Privacy Policy',
			'accountLockedNotification' => 'You have locked your account after several failed attempts.',
			'unlockAccountButton' => 'Unlock my account',
			'unlockAccountSuccess' => 'Your account is now unlocked.',
			'unlockAccount' => 'Unlock Account',
			'unlockAccountTitle' => 'Too many tries... No result.',
			'welcomeUseCaseAppBar' => 'Old BenzinApp User',
			'welcomeUseCase' => 'Welcome! Good to have you.',
			'welcomeUseCaseSubtitle' => 'You look familiar. Do we know you from somewhere?',
			'welcomeUseCaseYesButton' => 'Yes, I used to be a BenzinApp-BETA user.',
			'welcomeUseCaseNoButton' => 'I didn\'t use BenzinApp-BETA.',
			'claimCarSettings' => 'Claim an Old Car',
			'claimCarAppBar' => 'Claim Car',
			'claimCarTitle' => 'Of course we remember!',
			'claimCarTitleAlt' => 'You have an old car, after all',
			'claimCarSubtitle' => 'How could we possibly forget?',
			'claimCarSubtitleAlt' => 'Interesting! Don\'t forget about it again, though...',
			'enterExistingCarData' => 'Please enter your old car\'s account data:',
			'claimCarBackToDashboard' => 'Back to Dashboard',
			'claimCarButton' => 'Claim Car',
			'claimCarSuccess' => 'Successfully claimed old car.',
			'dashboardAppBar' => 'Dashboard',
			'dashboardMyCars' => 'My Cars',
			'dashboardSharedWithMe' => 'Shared With Me',
			'addNewCar' => 'Add a new car',
			'viewDetails' => 'View Details',
			'dashboardConfirmAccount' => 'Your account is not confirmed yet. You have limited features.',
			'successfullyCreatedCar' => 'Your car was successfully created.',
			'carMenuDetails' => ({required Object car}) => 'Details for ${car}',
			'carMenuView' => 'View Details',
			'carMenuEdit' => 'Edit Car Data',
			'carMenuShare' => 'Share with another user',
			'carMenuTransferOwnership' => 'Transfer car ownership',
			'carMenuDelete' => 'Delete',
			'carMenuLeaveCar' => 'Revoke invitation',
			'home' => 'Home',
			'fuelFills' => 'Fuel Fills',
			'maintenance' => 'Maintenance',
			'trips' => 'Trips',
			'settings' => 'Settings',
			'fuelFillNotificationTitle' => 'Unable to add fuel fill',
			'fuelFillNotificationBody' => 'There was a problem uploading the fuel fill. Possibly because the servers are down. Please try again.',
			'youPlannedYourFuelFill' => 'You planned your fuel fill?',
			'lastFilledToday' => 'Last filled today',
			'lastFilledYesterday' => 'Last filled yesterday',
			'lastFilledDaysAgo' => ({required Object amountOfDays}) => 'Last filled ${amountOfDays} days ago',
			'lastFilledAtDate' => ({required Object date}) => 'Last filled at ${date}',
			'insufficientDataTitle' => 'Insufficient Data!',
			'insufficientDataText' => 'Normally, here you will see a chart that displays your fuel fill records\' data over the course of time. You must have at least three  fuel fill records added in order for that to display here. Start adding fuel fill records and see the progress of your car\'s consumption here!',
			'fuelUsageTrend' => 'FUEL USAGE TREND',
			'combinedCosts' => 'COMBINED COSTS',
			'averageConsumption' => 'AVERAGE CONSUMPTION',
			'totalStatistics' => 'TOTAL STATISTICS',
			'litersPer100km' => ({required Object volUnit, required Object distUnit}) => '${volUnit} per 100 ${distUnit}:',
			'kilometersPerLiter' => ({required Object distUnit, required Object volUnit}) => '${distUnit} per ${volUnit}:',
			'costPerKilometer' => ({required Object unit}) => 'Cost per ${unit}:',
			'totalLitersFilled' => 'Total Petrol Filled:',
			'totalKilometersTravelled' => 'Total Distance Travelled:',
			'totalCosts' => 'Total Costs:',
			'serviceNotificationTitle' => 'Unable to add service',
			'serviceNotificationBody' => 'There was a problem uploading the service. Possibly because the servers are down. Please try again.',
			'serviceOverdueInDays' => ({required Object amount}) => 'Service overdue by ${amount} days',
			'serviceDueToday' => 'Service due today',
			'serviceDueTomorrow' => 'Service due tomorrow',
			'serviceDueInDays' => ({required Object amount}) => 'Service due in ${amount} days',
			'serviceDueInMonths' => ({required Object amount}) => 'Service due in ${amount} month(s)',
			'serviceDueInDateTime' => ({required Object date}) => 'Next service in ${date}',
			'nextServiceInKm' => ({required Object amount, required Object unit}) => 'Next service in ${amount} ${unit}.',
			'serviceOverdueInKm' => ({required Object amount, required Object unit}) => 'Service overdue by ${amount} ${unit}',
			'noFuelFillRecords' => 'No Fuel Fill Records.',
			'noMalfunctions' => 'No Malfunctions.',
			'noServices' => 'No Services.',
			'noTrips' => 'No Trips.',
			'repeatingTrips' => 'Repeating Trips',
			'oneTimeTrips' => 'One-Time Trips',
			'applicationAppearance' => 'Application Appearance',
			'darkMode' => 'Dark Mode',
			'language' => 'Language',
			'distanceMetric' => 'Distance Metric',
			'volumeMetric' => 'Volume Metric',
			'notificationSettings' => 'Notification Settings',
			'receiveEmailNotifications' => 'Receive extra e-mail notifications',
			'receivePushNotifications' => 'Receive in-app push notifications',
			'kilometersSetting' => 'Kilometers (km)',
			'milesSetting' => 'Miles (mi)',
			'litersSetting' => 'Liters',
			'gallonsSetting' => 'US Gallons',
			'carOptions' => 'Car Options',
			'accountSettings' => 'Account Settings',
			'fastLogin' => 'Fast Login',
			'editAccount' => 'Edit Account',
			'editCarData' => 'Edit Car Details',
			'inviteUserToCar' => 'Invite a User to this Car',
			'transferOwnership' => 'Transfer Car Ownership',
			'deleteCar' => 'Delete Car',
			'deleteAccount' => 'Delete Account',
			'invitations' => 'Invitations',
			'logout' => 'Logout',
			'aboutTheApp' => 'About the App',
			'privacyPolicy' => 'Privacy Policy',
			'termsAndConditions' => 'Terms and Conditions',
			'appInformation' => 'App Information',
			'edit' => 'Edit',
			'delete' => 'Delete',
			'malfunctions' => 'Malfunctions',
			'services' => 'Services',
			'filters' => 'Filters',
			'searchInFuelFills' => 'Search in fuel fills...',
			'totalRecords' => ({required Object totalRecords}) => '• ${totalRecords} Total Records',
			'totalFilteredRecords' => ({required Object totalRecords}) => '• ${totalRecords} with current filters',
			'oneRecord' => '• Only one record. Singular and lonely...',
			'oneRecordWithFilters' => '• One record with current filters',
			'confirmDeleteFuelFill' => 'Confirm Delete Fuel Fill',
			'confirmDeleteService' => 'Confirm Delete Service',
			'confirmDeleteMalfunction' => 'Confirm Delete Malfunction',
			'confirmDeleteTrips' => 'Confirm Delete Trip',
			'confirmDeleteGenericBody' => 'Are you sure? This action cannot be undone.',
			'cancel' => 'Cancel',
			'ok' => 'OK',
			'fuelFillRecordData' => 'Fuel Fill Record Data',
			'unspecified' => 'Unspecified',
			'liters' => 'Liters:',
			'kilometers' => 'Distance:',
			'cost' => 'Cost:',
			'consumption' => 'Consumption:',
			'efficiency' => 'Efficiency:',
			'travel_cost' => 'Travel Cost:',
			'comments' => 'Comments:',
			'nothingToShowHere' => 'Nothing to show here.',
			'editFuelFillRecord' => 'Edit Fuel Fill Record',
			'addFuelFillRecord' => 'Add Fuel Fill Record',
			'requiredInfo' => 'Required Info',
			'mileage' => 'Small Odometer',
			'totalMileage' => 'Big Odometer',
			'mileageTitle' => 'Odometer',
			'costPerVolume' => 'Fuel Cost',
			'costPerVolumeTitle' => ({required Object currency, required Object unit}) => '${currency}/${unit}',
			'fuelFillInfo' => 'Fuel Fill Info',
			'cost2' => 'Cost',
			'liters2' => 'Liters',
			'selectADate' => 'Select a date...',
			'pickADate' => 'Pick a date',
			'todayDate' => 'Today\'s date',
			'optionalInfo' => 'Optional Info',
			'fuelType' => 'Fuel Type',
			'station' => 'Station Name',
			'comments2' => 'Comments',
			'confirmAdd' => 'Confirm Add',
			'confirmEdit' => 'Confirm Changes',
			'inKmHint' => 'in km...',
			'costHint' => 'cost',
			'litersHint' => 'lt',
			'fuelTypeHint' => 'E.g. "FuelSave 95"',
			'stationHint' => 'E.g. "Shell" or "bp"',
			'commentsHint' => 'Anything useful about this fuel fill...',
			'noDateSelected' => 'You haven\'t selected a date yet.',
			'cannotBeEmpty' => 'Cannot be empty',
			'cannotBeNegative' => 'Must be positive',
			'invalidNumber' => 'Must be a positive number',
			'statsCannotBeCalculated' => 'Once you enter the next fuel fill, the stats of this one will become available.',
			'successfullyAddedFuelFill' => 'Successfully added Fuel Fill Record.',
			'successfullyUpdatedFuelFill' => 'Successfully updated Fuel Fill Record.',
			'successfullyDeletedFuelFill' => 'Successfully deleted Fuel Fill Record.',
			'odometerHintTitle1' => 'Small Odometer',
			'odometerBody1' => 'Small odometer refers to the travelled distance starting from the last time you fuelled your vehicle up until the next time. It\'s usually written right below your car\'s speedometer.',
			'odometerHintTitle2' => 'Big Odometer',
			'odometerBody2' => 'Big odometer refers to the total travelled distance of your car. It starts from when the car was bought. If the car is old, this number is usually really big, if the car used. It\'s usually written right below your car\'s speedometer',
			'gasPriceTitle' => 'Gas Price per Volume (liter)',
			'gasPriceBody' => 'Usually written on big electric boards that display a number with three decimals (x.xxx). This is price per liter and is a big part of calculation for the final price you will pay afterwards. If the price you see on the app is higher than the board, there\'s a good chance there\'s been a mistake in your fill-up and you were charged more.',
			'ffrStatsTitle1' => 'Liters',
			'ffrStatsBody1' => 'The total liters you filled in your car will be listed on the receipt and/or the pump. If you don\'t remember how many liters you filled, you can enter the cost per liter and the total cost. Then, the app will automatically calculate how many liters you put in the car.',
			'ffrStatsTitle2' => 'Cost',
			'ffrStatsBody2' => 'The final price you paid should be listed in the same place where the total liters are shown. You can also find this on your receipt.',
			'discoveredAt' => 'Discovered at:',
			'ongoingMalfunction' => 'Ongoing',
			'fixedMalfunction' => 'Fixed',
			'nextAtKm' => 'Next:',
			'at' => 'at',
			'orBefore' => 'or before',
			'before' => 'before',
			'malfunctionNotificationTitle' => 'Unable to add malfunction',
			'malfunctionNotificationBody' => 'There was a problem uploading the malfunction. Possibly because the servers are down. Please try again.',
			'malfunctionData' => 'Malfunction data',
			'dateDiscovered' => 'Date discovered:',
			'kilometersDiscovered' => 'Kilometers discovered:',
			'status' => 'Status:',
			'title' => 'Title:',
			'description' => 'Description:',
			'dateFixed' => 'Date fixed:',
			'locationFixed' => 'Location:',
			'successfullyAddedMalfunction' => 'Successfully added Malfunction.',
			'successfullyUpdatedMalfunction' => 'Successfully updated Malfunction.',
			'successfullyDeletedMalfunction' => 'Successfully deleted Malfunction.',
			'serviceData' => 'Service Data',
			'lastService' => 'Last Service',
			'previousServices' => 'Previous Services',
			'dateDone' => 'Date done:',
			'serviceMileage' => 'Service distance:',
			'nextServiceAt' => 'Next service at:',
			'selectNextServiceDate' => 'Next service date...',
			'location' => 'Location:',
			'seeOnMap' => 'See on map',
			'maintenanceCategory' => 'Maintenance Category',
			'selectMaintenanceType' => 'Select maintenance type:',
			'malfunction' => 'Malfunction',
			'service' => 'Service',
			'comingSoon' => 'Coming Soon...',
			'addService' => 'Add Service',
			'editService' => 'Edit Service',
			'serviceInfo' => 'Service Info',
			'description2' => 'Description',
			'serviceMileage2' => 'Service Distance',
			'nextServiceMileage' => 'Next Service Mileage',
			'descriptionHint' => 'What happened in this service?',
			'serviceMileageHint' => 'Enter service mileage...',
			'nextServiceInfo' => 'Next Service Info',
			'nextServiceMileageHint' => 'Enter next service mileage...',
			'confirmAddService' => 'Confirm Add Service',
			'successfullyAddedService' => 'Successfully added Service.',
			'successfullyUpdatedService' => 'Successfully updated Service.',
			'successfullyDeletedService' => 'Successfully deleted Service.',
			'addMalfunction' => 'Add Malfunction',
			'editMalfunction' => 'Edit Malfunction',
			'malfunctionInfo' => 'Malfunction Info',
			'malfunctionTitle' => 'Title',
			'malfunctionSeverity' => 'Malfunction Severity',
			'severityLowest' => 'Lowest',
			'severityLow' => 'Low',
			'severityNormal' => 'Normal',
			'severityHigh' => 'High',
			'severityHighest' => 'Highest',
			'malfunctionEnded' => 'Select end date...',
			'malfunctionTitleHint' => 'What\'s malfunctioning...?',
			'descriptionHintMalfunction' => 'Describe what is malfunctioning...',
			'pleaseSelectAnEndDate' => 'Please select an end date.',
			'iFixedThisMalfunction' => 'I fixed this malfunction',
			'repairData' => 'Repair Data',
			'repairCost' => 'Repair Cost',
			'repairCostHint' => 'Enter cost...',
			'uncheckingTheBox' => 'Warning! By unchecking the box, you will mark this functions as ongoing.',
			'selectLocation' => 'Select location...',
			'pleaseEnterFuelFills' => 'Trips rely on your data!',
			'atlEastThreeFuelFills' => 'Please enter at least 3 fuel fills to see the cost and consumption of your trips.',
			'tripNotificationTitle' => 'Unable to add trip',
			'tripNotificationBody' => 'There was a problem uploading the trip. Possibly because the servers are down. Please try again.',
			'tripData' => 'Trip Data',
			'tripName' => 'Title:',
			'weeklyOccurrence' => 'Weekly Occurrence:',
			'tripDistance' => 'Trip Distance:',
			'analyticsPerTime' => 'Analytics Per Time',
			'perTime' => 'per time',
			'weeklyAnalytics' => 'Weekly Analytics',
			'perWeek' => 'per week',
			'mapDetails' => 'Map Details',
			'showOnMaps' => 'Show on maps',
			'repeatingTimesPerWeek' => ({required Object n}) => 'Repeating ${n} times per week',
			'repeatingTimesPerWeekShort' => ({required Object n}) => '${n} times per week',
			'noRepeat' => 'Doesn\'t Repeat',
			'createdAt' => ({required Object date}) => 'Created at: ${date}',
			'bestCase' => 'Best case',
			'averageCase' => 'Average case',
			'worstCase' => 'Worst case',
			'oneTimeTrip' => 'One-time trip',
			'viewLocation' => 'View Location On Maps',
			'viewTrip' => 'View Tip On Maps',
			'origin' => 'Origin',
			'destination' => 'Destination',
			'addTrip' => 'Add Trip',
			'editTrip' => 'Edit Trip',
			'tripInfo' => 'Trip Info',
			'tripName2' => 'Trip\'s Title',
			'tripNameHint' => 'E.g.: "Trip to Florida" or "Home to Work"...',
			'timesRepeating' => 'Occurrence',
			'timesRepeatingHint' => 'Per Week',
			'makeTrip' => 'Make Trip...',
			'makeOnMaps' => 'Make on Maps',
			'pickAPlace' => 'Pick on Maps',
			'removeLocation' => 'Remove location',
			'deleteTrip' => 'Delete Trip',
			'createTrip' => 'Create Trip on Maps',
			'pickLocationOnMap' => 'Pick Location on Maps',
			'typeAnAddress' => 'Type an address, or long-press on the map.',
			'searchAddress' => 'Search Address',
			'searchAddressHintOrigin' => 'Type an address for the origin...',
			'searchAddressHintDestination' => 'Type an address for the destination...',
			'searchAddressHintLocation' => 'Type an address for the location...',
			'successfullyAddedTrip' => 'Successfully added Trip.',
			'successfullyUpdatedTrip' => 'Successfully updated Trip.',
			'successfullyDeletedTrip' => 'Successfully deleted Trip.',
			'from' => 'FROM',
			'to' => 'TO',
			'pleaseMakeATrip' => 'Please make a trip.',
			'noPlacesFoundWithThisAddress' => 'No places found with this address.',
			'noTripsFound' => 'There is no route available for the current positions.',
			'confirmTrip' => 'Confirm Trip',
			'useMyLocation' => 'Use my location',
			'swapOriginDestination' => 'Swap origin and destination',
			'longPressToSetOrigin' => 'Tip: long-press the map to set the origin.',
			'longPressToSetDestination' => 'Tip: long-press the map to set the destination.',
			'viaRoad' => ({required Object road}) => 'via ${road}',
			'locationUnavailable' => 'Couldn\'t get your location. Check that location is turned on and allowed for BenzinApp.',
			'routeRequestFailed' => 'Couldn\'t load routes. Check your connection and try again.',
			'confirmLocation' => 'Confirm Location',
			'fuelFilters' => 'Fuel Fill Filters',
			'malfunctionFilters' => 'Malfunction Filters',
			'serviceFilters' => 'Service Filters',
			'statusFilter' => 'Status',
			'severityFilter' => 'Severity',
			'allStatuses' => 'All Statuses',
			'onlyFixed' => 'Only Fixed',
			'onlyUnfixed' => 'Only Ongoing',
			'groupBy' => 'Group By',
			'groupNone' => 'None',
			'groupStatus' => 'Status',
			'groupSeverity' => 'Severity',
			'searchInMalfunctions' => 'Search in malfunctions...',
			'searchInServices' => 'Search in services...',
			'allSeverities' => 'All Severities',
			'searchHint' => 'Station, fuel type or ID',
			'fromDate' => 'From:',
			'toDate' => 'To:',
			'notSelected' => '<not selected>',
			'startKm' => ({required Object unit}) => 'From ${unit}',
			'endKm' => ({required Object unit}) => 'To ${unit}',
			'startLt' => ({required Object unit}) => 'From ${unit}',
			'endLt' => ({required Object unit}) => 'To ${unit}',
			'startTotalKm' => ({required Object unit}) => 'From total ${unit}',
			'endTotalKm' => ({required Object unit}) => 'To total ${unit}',
			'startCost' => 'From cost',
			'endCost' => 'To cost',
			'discard' => 'Discard',
			'apply' => 'Apply',
			'editCar' => 'Edit Car',
			'addCar' => 'Add Car',
			'successfullyUpdatedCar' => 'Successfully updated Car info.',
			'checkYourEmail' => 'Check your E-Mail. You should find a code.',
			'enterCode' => 'Once you find it, enter it here:',
			'resendButton' => 'Resend',
			'wrongCode' => 'Wrong or expired code',
			'emptyCode' => 'Please enter the code',
			'confirmAccount' => 'Confirm Account',
			'confirmButton' => 'Confirm',
			'confirmAccountTitle' => 'Let\'s verify your account',
			'skipVerification' => 'Skip verification for now.',
			'confirmAccountPleaseWait' => 'Please wait at least two (2) minutes.',
			'confirmAccountAlreadyConfirmed' => 'You were already confirmed. Sorry!',
			'confirmAccountSomethingElseWentWrong' => 'Something else went wrong. Please, try again later.',
			'skipConsequences' => 'What happens if I skip?',
			'skipConsequencesTitle1' => 'What happens if you skip?',
			'skipConsequencesText1' => 'Without confirming your account, your experience is limited. You can only have one car and one fuel fill, you can\'t use sharing or advanced features, and old BenzinApp users can\'t retrieve their previous cars.',
			'skipConsequencesText2' => 'You can confirm your account anytime from Settings --> User Settings --> Confirm Account. Unconfirmed users are reminded at every login.',
			'confirmAccountOkay' => 'Successfully confirmed your account',
			'forgotPasswordMenu' => 'Forgot Password',
			'resetPasswordMenu' => 'Reset Password',
			'forgotPasswordTitle' => 'Forgot your password?',
			'forgotPasswordSubtitle' => 'Tough one. But, it happens to the best of us.',
			'forgotPasswordEmailPrompt' => 'Please provide the e-mail associated with your account.',
			'forgotPasswordEmailLabel' => 'E-Mail',
			'forgotPasswordEmailHint' => 'Your account\'s email address...',
			'forgotPasswordNextStep' => 'Next Step',
			'forgotPasswordSecondStepTitle' => 'You\'re almost there!',
			'forgotPasswordSecondStepEnterPassword' => 'Then, enter a new password',
			'forgotPasswordSecondStepPasswordLabel' => 'New password',
			'forgotPasswordSecondStepPasswordHint' => 'Enter your new password...',
			'forgotPasswordSecondStepPasswordConfirmLabel' => 'Confirm Password',
			'forgotPasswordSecondStepPasswordConfirmHint' => 'Confirm your new password...',
			'forgotPasswordErrorSomethingElse' => ({required Object code}) => 'Something else went wrong. Error code: ${code}',
			'forgotPasswordSuccessfullyReset' => 'Successfully reset password',
			'forgotPasswordErrorTooEarly' => 'Requested a new code too early',
			'forgotPasswordFinishButton' => 'Finish',
			'general_invitations' => 'Invitations',
			'incoming' => 'Incoming',
			'outgoing' => 'Outgoing',
			'pending' => 'Pending',
			'accepted' => 'Accepted',
			'accepted_invitations' => 'Accepted Invitations',
			'pending_invitations' => 'Pending Invitations',
			'revoke' => 'Revoke',
			'leave' => 'Leave',
			'noInvitations' => 'No invitations',
			'sentAt' => ({required Object date}) => 'Sent at: ${date}',
			'confirm' => 'Confirm',
			'invitationAccepted' => 'Invitation Accepted.',
			'invitationCanceled' => 'Invitation Revoked.',
			'rejectInvitation' => 'Reject Invitation',
			'revokeInvitation' => 'Invoke Invitation',
			'cancelInvitation' => 'Cancel Invitation',
			'areYouSureYouWantToLeaveThisCar' => ({required Object car}) => 'Are you sure you want to leave from the car ${car}?',
			'areYouSureYouWantToRejectThisInvitation' => 'Are you sure you want to reject this invitation?',
			'areYouSureYouWantToRevokeAccess' => ({required Object user, required Object car}) => 'Are you sure you want to revoke access from ${user} regarding the car ${car}; (This user will no longer be able to see or edit the car\'s data)',
			'areYouSureYouWantToCancelInvitationForThisUser' => ({required Object user, required Object car}) => '${user} has yet to accept the invitation for the car ${car}. Are you sure you want to invoke this invitation?',
			'inviteUserToCarAppBar' => 'Invite User to Car',
			'inviteUserToCarTitle' => 'Share car details with friends',
			'inviteUserToCarSubtitle' => 'They\'ll love to see your statistics! No?',
			'enterUsernameToInvite' => 'Enter the associated username:',
			'sharedUsername' => 'Username',
			'sharedUsernameHint' => 'Enter your friend\'s username...',
			'sendInvitationButton' => 'Send Invitation',
			'invitationSent' => ({required Object user}) => 'Invitation sent to ${user}.',
			'invitationRejected' => 'Invitation rejected.',
			'selectAccessLevel' => 'Select access level:',
			'accessModerator' => 'Moderator',
			'accessViewer' => 'Viewer',
			'accessContributor' => 'Contributor',
			'accessLevel' => 'Access Level',
			'accessViewerDesc' => 'Viewers can see the data but not modify them.',
			'accessContributorDesc' => 'Contributors can see the data, add/update/delete them.',
			'accessModeratorDesc' => 'Moderators can see the data, add/update/delete them, and also invite other users to this car.',
			'deleteCarAppBar' => 'Delete Car',
			'deleteCarTitle' => ({required Object carName}) => 'Delete the car ${carName}',
			'deleteCarSubtitle' => '...and all of its data',
			'deleteCarEnterCarNameToDelete' => ({required Object carName}) => 'To confirm, please type "${carName}":',
			'deleteCarEnterCarName' => 'Retype car name',
			'deleteCarWarning' => 'Be careful! If you confirm the deletion, there\'s no way of redoing it. All of the car\'s fuel fill records, malfunctions, services, etc. will be permanently deleted.',
			'deleteCarButton' => 'Delete Car',
			'carDeletedSuccessfully' => 'Successfully deleted car',
			'carDeletionFailed' => 'Failed to delete car',
			'deleteAccountAppBar' => 'Delete Account',
			'deleteAccountTitle' => 'We will miss you...',
			'deleteAccountSubtitle' => 'he hope to see you again!',
			'deleteAccountWarning' => 'Be careful! Once you approve this, there\'s no going back! All your data -fuel fills, malfunctions, etc-, will be gone forever with no way of restoring it! Please be certain before approving this action.',
			'deleteAccountDangerZone' => 'Danger Zone',
			'deleteAccountRetypeUsernameTitle' => ({required Object username}) => 'To confirm the deletion, please type "${username}":',
			'deleteAccountRetypeUsername' => 'Re-type your username',
			'deleteAccountRetypePasswordTitle' => 'To confirm the deletion, please re-type your current password',
			'deleteAccountRetypePassword' => 'Re-type your password',
			'deleteAccountButton' => 'Delete Account',
			'accountDeletionFailed' => 'Could not delete account',
			'accountDeletedSuccessfully' => 'Account deleted successfully',
			'transferCarOwnershipAppBar' => 'Transfer Car Ownership',
			'transferCarOwnershipTitle' => 'Transfer the ownership',
			'transferCarOwnershipSubtitle' => 'You\'ll no longer be the owner of this car',
			'transferCarOwnershipWarning' => 'Be careful! If you confirm the ownership transfer, there\'s no way of redoing it. You\'ll be asked to confirm multiple times, once you select a user.',
			'transferCarOwnershipSelectUser' => 'Select a user',
			'transferCarOwnershipSelectUserTitle' => 'Please select the user you want to transfer the car to:',
			'transferCarOwnershipDangerZone' => 'You\'re entering the danger zone!',
			'transferCarOwnershipRetypeUsername' => 'Retype the username',
			'transferCarOwnershipRetypeUsernameTitle' => ({required Object username}) => 'To confirm the transfer, please type "${username}":',
			'transferCarOwnershipRetypeCarName' => 'Retype the car\'s name',
			'transferCarOwnershipRetypeCarNameTitle' => ({required Object carName}) => 'Confirm the transfer again and type "${carName}":',
			'transferCarOwnershipButton' => 'Transfer Ownership',
			'carTransferredSuccessfully' => 'Successfully transferred car\'s ownership',
			'carTransferFailed' => 'Failed to transfer car\'s ownership',
			'lastMonth' => 'Last 1 month',
			'lastTwoMonths' => 'Last 2 months',
			'lastThreeMonths' => 'Last 3 months',
			'lastFourMonths' => 'Last 4 months',
			'lastSixMonths' => 'Last 6 months',
			'lastTenMonths' => 'Last 10 months',
			'lastTwelveMonths' => 'Last 12 months',
			'lifetime' => 'Lifetime',
			'customRange' => 'Custom Range',
			_ => null,
		};
	}
}
