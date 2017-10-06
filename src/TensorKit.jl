# TensorKit.jl
#
# Main file for module TensorKit, a Julia package for working with
# with tensors, tensor operations and tensor factorizations

module TensorKit

# Exports
#---------
# Types:
export VectorSpace, Field, ElementarySpace, InnerProductSpace, EuclideanSpace # abstract vector spaces
export ComplexSpace, CartesianSpace, GeneralSpace, RepresentationSpace, ZNSpace # concrete spaces
export CompositeSpace, ProductSpace # composite spaces
export Sector, Irrep
export Abelian, SimpleNonAbelian, DegenerateNonAbelian, SymmetricBraiding, Bosonic, Fermionic, Anyonic # sector properties
export Parity, ZNIrrep, U1Irrep, SU2Irrep, FermionParity, FermionNumber, FermionSpin # specific sectors
export FusionTree
export IndexSpace, TensorSpace, AbstractTensorMap, AbstractTensor, TensorMap, Tensor # tensors and tensor properties
export TruncationScheme
export SpaceMismatch, SectorMismatch, IndexError # error types

# general vector space methods
export space, dual, dim, dims, fieldtype
# methods for sectors and properties thereof
export sectortype, fusiontype, braidingtype, sectors, Nsymbol, Fsymbol, Rsymbol, Bsymbol, frobeniusschur
export fusiontrees

# some unicode
export ⊕, ⊗, ×, ℂ, ℝ, ℤ₂, ℤ₃, ℤ₄, U₁, SU₂

# tensor operations: To be done
# export tensorcopy, tensoradd, tensortrace, tensorcontract, tensorproduct
# export tensorcopy!, tensoradd!, tensortrace!, tensorcontract!, tensorproduct!

# tensor factorizations
export leftorth, rightorth, leftorth!, rightorth!, svd!

# truncation schemes
export notrunc, truncerr, truncdim, truncspace

# tensor maps
export domain, codomain

# Imports
#---------
using Base: tuple_type_head, tuple_type_tail, tuple_type_cons, tail, front, setindex
using Base: ImmutableDict

if VERSION <= v"0.6.0"
    include("auxiliary/product.jl")
    using Product.product
else
    using Base: Iterators.product
end

if VERSION < v"0.7.0-DEV.843"
    Base.@pure Base.Val(N) = Val{N}
end

include("auxiliary/auxiliary.jl")
include("auxiliary/linalg.jl")
include("auxiliary/stridedview.jl")

if VERSION < v"0.7.0-DEV.1415"
    const adjoint = Base.ctranspose
else
    import Base.adjoint
end

# Exception types:
#------------------
abstract type TensorException <: Exception end

# Exception type for all errors related to sector mismatch
struct SectorMismatch{S<:Union{Void,String}} <: TensorException
    message::S
end
SectorMismatch()=SectorMismatch{Void}(nothing)
Base.show(io::IO, ::SectorMismatch{Void}) = print(io, "SectorMismatch()")

# Exception type for all errors related to vector space mismatch
struct SpaceMismatch{S<:Union{Void,String}} <: TensorException
    message::S
end
SpaceMismatch()=SpaceMismatch{Void}(nothing)
Base.show(io::IO, ::SpaceMismatch{Void}) = print(io, "SpaceMismatch()")

# Exception type for all errors related to invalid tensor index specification.
struct IndexError{S<:Union{Void,String}} <: TensorException
    message::S
end
IndexError()=IndexError{Void}(nothing)
Base.show(io::IO, ::IndexError{Void}) = print(io, "IndexError()")

# Tensor product operator
#-------------------------
⊗(a, b, c, d...)=⊗(a, ⊗(b, c, d...))

# Definitions and methods for superselection sectors (quantum numbers)
#----------------------------------------------------------------------
include("sectors/sectors.jl")

# Definitions and methods for vector spaces
#-------------------------------------------
include("spaces/vectorspaces.jl")

# Constructing and manipulating fusion trees and iterators thereof
#------------------------------------------------------------------
include("fusiontrees/fusiontrees.jl")

# # Definitions and methods for tensors
# #-------------------------------------
# import TensorOperations
# intentionally shadow original TensorOperation methods for StridedArray objects

# define truncation schemes for tensors
include("tensors/truncation.jl")
# general definitions
include("tensors/abstracttensor.jl")
include("tensors/tensor.jl")

end