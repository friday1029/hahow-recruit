class Api::V1::CoursesController < ActionController::Base
  before_action :set_course, only: %i[ show update destroy ]
  protect_from_forgery with: :null_session # @todo 先關掉 CSRF, 後續用是否登入擋.

  def index
    @courses = Course.includes(:chapters).order(:id)
    render json: {
      courses: @courses.map{ |course| {course: show_course(course)}}
    }
  end

  def show
    render json: {
      course: show_course(@course)
    }
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      # @todo,refactor 各method render json方式
      render json: {
        course: show_course(@course),
        status: :ok
      }
    else
      render json: {
        message: @course.errors.full_messages,
        status: :ng
      }
    end
  end

  def update
    if @course.update(course_params)
      render json: {
        course: show_course(@course),
        status: :ok
      }
    else
      render json: {
        message: @course.errors.full_messages,
        status: :ng
      }
    end
  end

  def destroy
    #@todo, 判斷是否有刪除的權限
    course_id = @course.id
    if @course.destroy
      render json: {
        course: {id: course_id},
        status: :ok
      }
    else
      render json: {
        message: @course.errors.full_messages,
        status: :ng
      }
    end
  end

  private
    def show_course course
      course.attributes.merge(
        chapters: course.chapters.order(seq: :asc).map{ |chapter| chapter.attributes.merge(show_chapter(chapter)) }
      )
    end

    def show_chapter chapter
      chapter.attributes.merge(
        units: chapter.units.order(seq: :asc)
      )
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.includes(:chapters).find_by(id: params[:id])
      if @course.blank?
        return render json: {
          message: '物件不存在',
          status: :ng
        }
      end
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name, :desc, :lecturer, 
        chapters_attributes: [:id, :name, :seq, :_destroy, 
          units_attributes: [:id, :name, :desc, :content, :seq, :_destroy] 
        ]
      )
    end
end
