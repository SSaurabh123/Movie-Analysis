install.packages("recommenderlab")

library(recommenderlab)

MovieLense

## visualize part of the matrix
image(sample(MovieLense, 500), main = "Ratings")

## number of ratings per user
hist(rowCounts(MovieLense))

## number of ratings per movie
hist(colCounts(MovieLense))

## mean rating (averaged over users)
mean(rowMeans(MovieLense))

qplot(getRatings(MovieLense), binwidth = 1, 
      main = "Histogram Showing Rating of Movie", xlab= "Rating")



qplot(rowCounts(MovieLense), binwidth = 10, 
      main = "Movies Rated on average", 
      xlab = "No of users", 
      ylab = "No of movies rated")


qplot(colMeans(MovieLense), binwidth = .1, 
      main = "Mean rating of Movies", 
      xlab = "Rating", 
      ylab = "No of movies")



recommenderRegistry$get_entries(dataType = "realRatingMatrix")
# We have a few options

# Let's check some algorithms against each other
scheme <- evaluationScheme(MovieLense, method = "split", train = .9,
                           k = 1, given = 10, goodRating = 4)

scheme

algorithms <- list(
  "random items" = list(name="RANDOM", param=list(normalize = "Z-score")),
  "popular items" = list(name="POPULAR", param=list(normalize = "Z-score")),
  "user-based CF" = list(name="UBCF", param=list(normalize = "Z-score",
                                                 method="Cosine",
                                                 nn=50, minRating=3)),
  "item-based CF" = list(name="IBCF2", param=list(normalize = "Z-score"
  ))
  
)

# run algorithms, predict next n movies
results <- evaluate(scheme, algorithms, n=c(1, 3, 5, 10, 15, 20))

# Draw ROC curve
plot(results, annotate = 1:4, legend="topleft")

# See precision / recall
plot(results, "prec/rec", annotate=3)
