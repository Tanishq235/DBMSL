use school;

db.students.insertMany([
  { _id: 1, name: "Ravi",   age: 18, marks: 85, city: "Pune",    hobbies: ["reading", "cycling"] },
  { _id: 2, name: "Asha",   age: 17, marks: 92, city: "Mumbai",  hobbies: ["painting", "music"] },
  { _id: 3, name: "Vikram", age: 18, marks: 70, city: "Pune",    hobbies: ["reading", "chess"] },
  { _id: 4, name: "Neha",   age: 19, marks: 88, city: "Delhi",   hobbies: ["music", "travel"] },
  { _id: 5, name: "Sara",   age: 18, marks: 95, city: "Mumbai",  hobbies: ["cycling", "music"] }
]);

db.students.aggregate([
  { $match: { marks: { $gte: 85 } } }
]).pretty();

db.students.aggregate([
  { $group: { _id: "$city", avgMarks: { $avg: "$marks" }, totalStudents: { $sum: 1 } } }
]).pretty();

db.students.aggregate([
  {
    $project: {
      _id: 0,
      name: 1,
      city: 1,
      marks: 1,
      grade: {
        $cond: [
          { $gte: ["$marks", 90] }, "A",
          { $cond: [ { $gte: ["$marks", 80] }, "B", "C" ] }
        ]
      }
    }
  }
]).pretty();

db.students.aggregate([
  { $sort: { marks: -1 } }
]).pretty();

db.students.aggregate([
  { $unwind: "$hobbies" }
]).pretty();

db.students.aggregate([
  { $unwind: "$hobbies" },
  { $group: { _id: "$hobbies", count: { $sum: 1 } } },
  { $project: { _id: 0, hobby: "$_id", count: 1 } },
  { $sort: { count: -1 } }
]).pretty();

db.students.createIndex({ city: 1 });
db.students.createIndex({ marks: -1 });
db.students.createIndex({ hobbies: 1 });

db.students.getIndexes();

db.students.find({ city: "Pune" }).sort({ marks: -1 }).explain("executionStats");
