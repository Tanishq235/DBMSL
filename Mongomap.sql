db.Sales.insertMany([
  { salesperson: "John", amount: 500 },
  { salesperson: "Mary", amount: 300 },
  { salesperson: "John", amount: 700 },
  { salesperson: "Alice", amount: 400 },
  { salesperson: "Mary", amount: 200 }
]);

var mapFunction = function() {
    emit(this.salesperson, this.amount);
};

var reduceFunction = function(salesperson, amounts) {
    return Array.sum(amounts);
};

db.Sales.mapReduce(
    mapFunction,
    reduceFunction,
    { out: "TotalSalesByPerson" }  // Output collection
);

db.TotalSalesByPerson.find().pretty();
