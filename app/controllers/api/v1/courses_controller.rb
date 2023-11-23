class Api::V1::CoursesController < ActionController::Base
  before_action :set_course, only: %i[ show update destroy ]
  protect_from_forgery with: :null_session # @todo 先關掉 CSRF, 後續用是否登入擋.

  def index
    @courses = Course.all
    render json: {
      courses: @courses
    }
  end

  def show
    render json: {
      course: @course
    }
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      # @todo,refactor 各method render json方式
      render json: {
        course: @course,
        status: :ok
      }
    else
      render json: {
        message: @course.errors,
        status: :ng
      }
    end
  end

  def update
    if @course.update(course_params)
      render json: {
        course: @course,
        status: :ok
      }
    else
      render json: {
        message: @course.errors,
        status: :ng
      }
    end
  end

  def destroy
    #@todo, 判斷是否有刪除的權限
    if @course.present?
      course_id = @course.id
      if @course.destroy
        render json: {
          course: {id: course_id},
          status: :ok
        }
      else
        render json: {
          message: @course.errors,
          status: :ng
        }
      end
    else
      render json: {
        message: '物件不存在',
        status: :ng
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name, :desc, :lecturer)
    end
end
