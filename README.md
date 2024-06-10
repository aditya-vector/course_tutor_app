# README

### Overview
CourseTutorApp is an API only Rails application designed to manage courses and their associated tutors. A course can have multiple tutors, but each tutor can only teach one course.

### Ruby Version
- 3.3.0

### Rails Version
- 7.1.3

### Database
- Sqlite3

### Installation

1. Clone the repository
2. Run `bundle install`
3. Run `rails db:migrate`
4. Run `rails db:seed`
5. Run `rails s`

### Run Tests
Run `bundle exec rspec` to run the test suite.

### API Endpoints

#### Courses

1. **GET /api/v1/courses** - Returns a list of all courses
  - **Sucessful Response**
    - status: 201 Created
    - body:
      ```json
      {
        "courses": [
          {
            "id": 1,
            "name": "Course 1",
            "created_at": "2021-07-11T17:00:00.000Z",
            "updated_at": "2021-07-11T17:00:00.000Z",
            "tutors": [
              {
                "id": 1,
                "name": "Tutor 1",
                "created_at": "2021-07-11T17:00:00.000Z",
                "updated_at": "2021-07-11T17:00:00.000Z"
              }
            ]
          }
        ]
      }
      ```
  - **Error Response**
    - status: 422 Unprocessable Entity
    - body:
      ```json
      {
        "error": "Course - Name can't be blank"
      }
      ```
2. **POST /api/v1/courses** - Create a new course along with optional tutors
  - **Request**
    ```json
    {
      "course": {
        "name": "Course 2",
        "tutors": [
          {
            "name": "Tutor 2"
          },
          {
            "name": "Tutor 3"
          }
        ]
      }
    }
    ```
  - **Response**
    ```json
    {
      "course": {
        "id": 2,
        "name": "Course 2",
        "created_at": "2021-07-11T17:00:00.000Z",
        "updated_at": "2021-07-11T17:00:00.000Z",
        "tutors": [
          {
            "id": 2,
            "name": "Tutor 2",
            "created_at": "2021-07-11T17:00:00.000Z",
            "updated_at": "2021-07-11T17:00:00.000Z"
          },
          {
            "id": 3,
            "name": "Tutor 3",
            "created_at": "2021-07-11T17:00:00.000Z",
            "updated_at": "2021-07-11T17:00:00.000Z"
          }
        ]
      }
    }
    ```


### Models

1. **Course**
  - name: string
  - created_at: datetime
  - updated_at: datetime
2. **Tutor**
  - name: string
  - course_id: integer
  - created_at: datetime
  - updated_at: datetime
