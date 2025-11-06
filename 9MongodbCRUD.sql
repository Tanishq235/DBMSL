db.students.insertOne({ name: "Neha", age: 19, marks: 88, city: "Delhi" });
db.students.insertMany([
  { name: "Raj", age: 17, marks: 75, city: "Pune" },
  { name: "Sara", age: 18, marks: 95, city: "Mumbai" }
]);
db.students.find();
db.students.find({}, { name: 1, marks: 1, _id: 0 });
db.students.find({ $and: [ { city: "Pune" }, { marks: { $gt: 80 } } ] });
db.students.find({ $or: [ { city: "Pune" }, { city: "Mumbai" } ] });
db.students.updateOne(
  { name: "Ravi" },
  { $set: { marks: 90 } }
);
db.students.updateMany(
  { city: "Pune" },
  { $inc: { marks: 5 } } 
);
db.students.deleteOne({ name: "Raj" });
db.students.deleteMany({ city: "Mumbai" });
db.students.find().pretty();


