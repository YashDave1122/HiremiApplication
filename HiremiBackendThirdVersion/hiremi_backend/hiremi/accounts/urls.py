# from django.urls import include, path
# from rest_framework.routers import DefaultRouter

# from .views import AccountViewSet, CityViewSet, StateViewSet

# router = DefaultRouter()
# router.register(r"accounts", AccountViewSet, basename="account")
# router.register(r"states", StateViewSet, basename="state")
# router.register(r"cities", CityViewSet, basename="city")

# urlpatterns = [
#     path("", include(router.urls)),
# ]
from django.urls import include, path
from rest_framework.routers import DefaultRouter

from .views import AccountViewSet, CorporateDiscountViewSet, CorporateViewSet, DiscountViewSet, LiveProjectApplicationViewSet, LiveProjectViewSet,  MentorshipDiscountViewSet, MentorshipViewSet, TrainingProgramApplicationViewSet, TrainingProgramViewSet, get_cities, get_state_cities, get_states,get_city,get_city_by_id

router = DefaultRouter()
router.register(r"accounts", AccountViewSet, basename="account")
router.register(r'discount', DiscountViewSet, basename='discount')
router.register(r'corporatediscount', CorporateDiscountViewSet, basename='corporatediscount')
router.register(r'mentorshipdiscount', MentorshipDiscountViewSet, basename='mentorshipdiscount')
router.register(r'mentorship', MentorshipViewSet, basename='mentorship')
router.register(r'corporatetraining', CorporateViewSet, basename='corporatetraining')
router.register(r'Training', TrainingProgramViewSet)
router.register(r'training-applications', TrainingProgramApplicationViewSet, basename='training-applications')
router.register(r'liveProject', LiveProjectViewSet)

router.register(r'LiveProjectHub-applications', LiveProjectApplicationViewSet, basename='LiveProjectHub-applications')




# router.register(r"states", StateViewSet, basename="state")
# router.register(r"cities", CityViewSet, basename="city")

urlpatterns = [
    path("", include(router.urls)),
    path('states/', get_states, name='states'),
    path('cities/', get_cities, name='cities'),
    path('states/<str:state_name>/cities/', get_state_cities, name='state-cities'),
    path('states/<str:state_name>/cities/<int:city_id>/', get_city, name='get_city'),  # New pattern
    path('cities/<int:city_id>/', get_city_by_id, name='get_city_by_id'),  # ✅ New route
    
]