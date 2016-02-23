/**
 * green-thumb
 *
 * Read temperature and humidity values from an SHT1x-series (SHT10,
 * SHT11, SHT15) sensor, and save data to a CSV file.
 *
 * Author:	J. Carlos M. Vaso
 * Date:	2016-02-21
 */

#include "core.h"
#include "SHT1x.h"

#include "unitstd.h"

// Specify data and clock connections and instantiate SHT1x object
int data_pin = 10;
int clock_pin = 11;

SHT1x* sht1x = NULL;

// CSV vars
char csv_file[

/**
 * Wrapper to get the temperature from the SHT1x sensor.
 * 
 * \return	Temperature in degrees Celsius as a float.
 */
float getTemp()
{
	return sht1x->readTemperatureC();
}

/**
 * Wrapper to get humidity from the SHT1x sensor.
 * 
 * \return	Relative humidity in % as a float.
 */
float getHumidity()
{
	return sht1x->readHumidity();
}

/**
 * Write data to CSV file.
 * 
 * \param [in]	file_path	Path to the CSV file.
 * \param [in]	timestamp	Timestamp.
 * \param [in]	temperature	Temperature.
 * \param [in]	humidity	Humidity.
 * \return		Error code.
 */
int writeCSV(string file_path, string timestamp, float temperature, float humidity)
{
	char data[256];
	FILE* fp;
	
	// Create data string

	// Check if file exists and make it if it does not exsist
	if( access( fname, F_OK ) != -1 ) {
		// File exists: open to append data
		fp = fopen(file_path, "a+");
		fprintf(fp, data);
		fclose(fp);
	} else {
		// File doesn't exist: create file, and add header and data
		fp = fopen(file_path, "a");
		fprintf(fp, csv_header);
		fprintf(fp, data);
		fclose(fp);
	}
	
	return 0;
}

/**
 * Setup.
 */
void setup()
{
#ifndef PCDUINO_IDE
	if(argc != 3){ 
		goto _help;
	}   
	
	data_pin = atoi(argv[1]);
	clock_pin = atoi(argv[2]);
#endif
	
	printf("Starting up\n");
	printf("Data Pin: %d\nClock Pin: %d\n\n", data_pin, clock_pin);
	
	sht1x = new SHT1x(data_pin, clock_pin);
	return;

_help:
	printf("Usage %s DATA_PIN(0-13) CLOCK_PIN(0-13)\n", argv[0]);
	exit(-1);
}

/**
 * Main loop.
 */
void loop()
{
  float temp;
  float humidity;

  // Read values from the sensor

  // Print the values to STDOUT
  printf("Temperature: ");
  printf("%.1f", temp_c);
  printf(" C / ");
  printf("%.1f", temp_f);
  printf(" F\nHumidity: ");
  printf("%.1f", humidity);
  printf(" %%\n");

  delay(2000);
}
