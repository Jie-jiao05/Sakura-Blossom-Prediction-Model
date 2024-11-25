#### Preamble ####
# Purpose: Scrape temperature data
# Author: Shanjie Jiao
# Date: 18 November 2024 
# Contact: Shanjie.Jiao@mail.utoronto.ca
# License: MIT
# Pre-requisites: No
# Any other information needed? No


#### Workspace Setup ####

# Load required packages
library(tidyverse)
library(rvest)
library(lubridate)


#### Define Scraping Function ####

scrape_temps <- function(station_id) {
  url <- paste0("https://www.data.jma.go.jp/obd/stats/etrn/view/monthly_s3_en.php?block_no=", station_id, "&view=1")
  message("Scraping station ID: ", station_id)
  
  table <- tryCatch({
    read_html(url) %>%
      html_node(".data2_s") %>%
      html_table(fill = TRUE) %>%
      as_tibble()
  }, error = function(e) {
    message("Error scraping station ID: ", station_id)
    return(NULL)
  })
  
  if (!is.null(table)) {
    table %>%
      rename_with(~ str_trim(.), everything()) %>%  # Remove extra whitespace in column names
      select(-Annual) %>%  # Drop the `Annual` column
      rename(year = Year) %>%  # Rename `Year` for consistency
      mutate(across(Jan:Dec, ~ if (is.character(.)) {
        suppressWarnings(parse_number(., na = c("", "ã€€", "N/A", "—")))
      } else {
        .
      })) %>%  # Handle numeric or character month values
      pivot_longer(cols = Jan:Dec, names_to = "month", values_to = "mean_temp_c") %>%  # Reshape the data
      mutate(
        month_date = ymd(paste(year, month, "01", sep = "-")),  # Create a full date for each month
        year = as.integer(year),  # Ensure the year is an integer
        station_id = station_id  # Add the station ID
      ) %>%
      filter(between(year, 1953, 2023)) %>%  # Filter the years
      select(station_id, year, month, month_date, mean_temp_c)  # Select relevant columns
  } else {
    NULL
  }
}


#### Scrape Data ####

# Define the station lookup table
station_lookup <- tibble(
  station_id = c(47401, 47406, 47407, 47409, 47412, 47413, 47417, 47418, 47420, 47423,
                 47426, 47428, 47430, 47433, 47435, 47440, 47520, 47575, 47581, 47582,
                 47584, 47585, 47587, 47588, 47590, 47595, 47597, 47598, 47600, 47602,
                 47604, 47605, 47607, 47610, 47612, 47615, 47616, 47617, 47618, 47624,
                 47626, 47629, 47631, 47632, 47636, 47637, 47638, 47648, 47651, 47654,
                 47662, 47663, 47670, 47672, 47675, 47677, 47678, 47740, 47741, 47744,
                 47746, 47747, 47750, 47755, 47759, 47761, 47762, 47765, 47768, 47770,
                 47772, 47776, 47777, 47778, 47780, 47800, 47807, 47813, 47815, 47817,
                 47819, 47822, 47827, 47830, 47836, 47837, 47843, 47887, 47891, 47892,
                 47893, 47895, 47909, 47912, 47917, 47918, 47927, 47929, 47936, 47940),
  station_name = c("Wakkanai", "Rumoi", "Asahikawa", "Abashiri", "Sapporo", "Iwamizawa",
                   "Obihiro", "Kushiro", "Nemuro", "Muroran", "Urakawa", "Esashi", "Hakodate",
                   "Kutchan", "Mombetsu", "Hiroo", "Shinjo", "Aomori", "Hachinohe", "Akita",
                   "Morioka", "Miyako", "Sakata", "Yamagata", "Sendai", "Fukushima", "Shirakawa",
                   "Onahama", "Wajima", "Aikawa", "Niigata", "Kanazawa", "Toyama", "Nagano",
                   "Takada", "Utsunomiya", "Fukui", "Takayama", "Matsumoto", "Maebashi",
                   "Kumagaya", "Mito", "Tsuruga", "Gifu", "Nagoya", "Iida", "Kofu", "Choshi",
                   "Tsu", "Hamamatsu", "Tokyo", "Owase", "Yokohama", "Tateyama", "Oshima",
                   "Miyakejima", "Hachijojima", "Saigo", "Matsue", "Yonago", "Tottori",
                   "Toyooka", "Maizuru", "Hamada", "Kyoto", "Hikone", "Shimonoseki",
                   "Hiroshima", "Okayama", "Kobe", "Osaka", "Sumoto", "Wakayama",
                   "Shionomisaki", "Nara", "Izuhara", "Fukuoka", "Saga", "Oita", "Nagasaki",
                   "Kumamoto", "Nobeoka", "Kagoshima", "Miyazaki", "Yakushima", "Tanegashima",
                   "Fukue", "Matsuyama", "Takamatsu", "Uwajima", "Kochi", "Tokushima",
                   "Naze", "Yonagunijima", "Iriomotejima", "Ishigakijima", "Miyakojima",
                   "Kumejima", "Naha", "Nago")
)
# Initialize data and error lists
scraped_data <- list()
errors <- list()

# Scrape data for each station
for (i in seq_along(station_lookup$station_id)) {
  station_id <- station_lookup$station_id[i]
  message(sprintf("Processing %d of %d: Station ID %s", i, length(station_lookup$station_id), station_id))
  Sys.sleep(2)  # Add delay between requests
  result <- scrape_temps(station_id)
  if (!is.null(result)) {
    scraped_data[[as.character(station_id)]] <- result
  } else {
    errors[[as.character(station_id)]] <- paste("Failed for station ID:", station_id)
  }
}

# Combine all successful data
final_data <- bind_rows(scraped_data)

# Merge the `station_name` from the lookup table
final_data <- final_data %>%
  left_join(station_lookup, by = "station_id") %>%
  select(station_id, station_name, everything())  # Reorder columns

# Save the final dataset to the CSV file
if (!is.null(final_data) && nrow(final_data) > 0) {
  write_csv(final_data, file = file.path(output_dir, "temperature_data.csv"))
  message("Final data successfully saved to: ", file.path(output_dir, "temperature_data.csv"))
} else {
  stop("No data was scraped or generated; output file not created.")
}